# Implement BLOC Provider into Stories View

## The difference in sink.add

For the previous lecture, our **sink.add** only take a String in a Widget whenever it changed.
But now our **sink** must take top Ids automatically from a **Repository.fetchTopIds()**.

So we add a **Repository** instance into BLoC and we that to add a List of top Ids from **fetchTopIds()** into **sink**. REMEMBER: this is no longer a Getter function anymore so pass List as a argument.

Okay, it's good to go to refactor code to make it use Scoped BLoC from Landing Page.

## Create Stories Provider & BLOC

At this stage, we can use predefine **Provider** library or define own Provider. If use self-defined Provider we must follow rules:
- Method **updateShouldNotify**, static **of** method and contructor with **child** attribute.
- Final attribute **StoriesBloc**.
- Inside **StoriesBloc** class, must have **Repository** instances and and **PublishSubject** (StreamController for list of Ids).
    - Because of StreamController so we should have **getter** for **stream** and **sink.add(list of Ids)**.
    - **NOTE:** Remember to close StreamController

After define all neccessary class, we can implement **Provider** to our code.

## Test BLOC

From BLOC, we can use **Repository** to extract top Ids so at the body of **Scaffold** we can implement test Widget to show ListView of Ids or ProgessIndicator.
- This function takes **BLOC** as a parameter so we should import **StoriesBloc** class but to keep Encapsulation meaning we shouldn't.
- Instead, we add ```export 'stories_bloc.dart';``` in **StoriesProvider**. So whenever use that class, it will export 2 classes: Provider and BLOC.

And for every time we open HomePage, we should fetch new Top Ids list so in **build()** should include **bloc.fetchTopIds()**.
- But this is very dangerous way to solve because the fetching time and error-handling.

# Make Efficiency Item Fetching

## Fetching Architecture

```
    NewsList                    |   StoriesBloc components
        |                       |
        v                       |
    StreamBuilder       <--     | TopIds StreamController.stream         
        |                       |
        v                       |
    ListView.builder    -->     | Items StreamController.sink
                                |              
--------------------------------|
|               |               |
v               v               |
StreamBuilder   StreamBuilder   |   <-- Items StreamController.stream
|               |
v               v
FutureBuilder   FutureBuilder
```

The top StreamBuilder is to listen at the interval time to get `List<int> of TopIds`.

Then from each Ids in that `List<int>`, we can call request for each item. The Items StreamController takes ids then process it and put back ItemModel for Ids to stream.

The type of result in stream should be `Future<ItemModel>` because of retrieve data from DB or API.

**NOTE:** This is not necessary for every app with request API. But this is the optimize for the process.

## Big Bump in new StreamController in StoriesBloc (sector 14 - Type design)

**NOTE:** For each StreamBuilder in ListView, it be hooked with stream in Items StreamController.

So there for whenever it emits a value, all StreamBuilder will get it.

The situation can occur wrongly because:
- If we have 3 streamBuilder, each is looking for specific id.
- Stream will emit 3 ItemModel respectively after receive 3 ids.
- StreamBuilder will build sucessfully, but StreamBuilder 1 will not so anything block after BF

**Conclusion**: 
- After the first ItemModel, it will go fine but problem appears after the second
- Because we're using Stateless Widget, it can't tell that the first ListView item is already occupied so the second item has data but the first go to **CircularProgessIndicator** status.

## The workaround for problem

Our solution from **rx library - rx_transformers** with specific Stream - Transformer: **ScanStreamTransformer**:
- Applies an accumulator function over an observable sequence and returns each intermediate result. The optional seed value is used as the initial accumulator value.

**What it does ?** It works like **functool.reduce() in Python** take accumulate value and list of value, it will iterate through every items and perform a action between accumulate value and an item.

```dart
_itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }
```

Parameters in **ScanStreamTransformer**:
- 1st is a Function to handle data stream and its accumulate value.
    - Function requires other 3 para: **accumulate** var, each items from stream and index (which is not neccessary)
    - REMEMBER: to return the value for accumulate value.
- 2nd is **Initial value for accumulate**

Now it's ready to use as **.transfrom(_itemsTransformer)** to make a **Map from every object (int value) exist in Stream**.

<!-- EXPLAIN code for Items Stream Controller (BehaviourSubject - Observable) -->
## Finishing Items StreamController 

Our main goal for StreamBuilder for each news tile is it can lookup specific news from a map of ID - News.
So we use **BehaviourSubject** to always get the latest item from stream. And the data put in stream is always **Map<int, Future< ItemModel>>**

But here we have another problem: We can't create **getter for Items stream or Items stream transform** as TopIds. Because:
- StreamBuilder for each News Tile is used this to display content. 
- So every StreamBuilder will call stream to transform once time.
- And new instance of Map is created every time for a tile -> **Waste time & space**.

Solution:
- Make Items stream transforms ONLY 1 TIME at the beginning of BLOC
- The result of transformation (Observable) is the source for StreamBuilder.
- And each times to display a tile, it make a request to **fetchItem()** with ItemID to Items sink. 

### Code Note

```dart
_items = BehaviourSubject<int>();       // StreamController ID of items will be fetched
Function(int) get fetchItem => _items.sink.add;
```

This is synomym (getter) of a function to hide function code from others and which indicates getter returns a function requires a int value. 

To use we can call **bloc.fetchItem(1)** for example, which is the same as **_items.sink.add(1)**

<!-- EXPLAIN code for widget NEWS TILE -->
## Widget News Tile

Every tile of news display on main is identified by a **value from TopIds stream** or **id in ItemModel**. We can use by a lot for fetching (**bloc.fetchItem()**) or get ItemModel from cache map.

Anything else is nothing special expect few keynotes:
- Check out correct type and name of AsyncSnapShot for **StreamBuilder** and **FutureBuilder**. 
- AsyncSnapShot for **StreamBuilder** is the same type as **stream** parameter.
- AsyncSnapShot for **FutureBuilder** is the same type as **future** parameter without *Future*.

<!-- EXPLAIN 2 PROBLEMS in designing news tile (vid 24) -->
### Overfetching problems - Gotcha

To this moment, we will encounter a problem that it fetchs too much data than it actually could (40 000 ItemModel compare to 500 ItemModel in TopIds).

The problem behind it is [**Stream Subscription**](https://api.dart.dev/stable/2.7.1/dart-async/StreamSubscription-class.html).

What we're currently doing is *every StreamBuilder in NewsTile listen() to Items Broadcast Stream*:
- And function *listen()* return something is: **StreamSubscription**
- The subscription provides events to the listener.
- So whenever a StreamBuilder calls *listen()*, the broadcast stream will return a **StreamSubscription** as a middle-man.
- When Stream emits a **event**, that event will go through every StreamSubscription then go to StreamBuilder.
- And what we are hoping is:

```
 ----------        --------------       | StreamSubscription | --> StreamBuilder
|  Items   |      |              |      |
| Broadcast|  --> | transformers | -->  | StreamSubscription | --> StreamBuilder
| Stream   |      |              |      |
|          |      |              |      | StreamSubscription | --> StreamBuilder
 ----------        --------------
```

But in reality, all StreamSubscription pass *event* to **transformer** then this transformed event go to every single StreamBuilder:
- This lead to the SAME EVENT is transformed multiple times (number of times = number of StreamBuilders).
- And the result is it shows N x N data which drives code crazy.

### Solution

We make 2 separate StreamController (**Subject**) to do 2 different works:
- **_itemsFetcher** to do the work with transformer.
- **_itemsOutput** to do the work with every StreamBuilder.

So our flow will be:

```
itemsFetcher    -->   transformer   -->   itemsOutput     -->   StreamSubscription(s)  --> StreamBuilder(s)
StreamController                          StreamController
```

Because **_itemsTransformer** previously takes stream of int and output stream of **`Map<int, Future<ItemModel>>`** then:
- **itemsFetcher**: PublishSubject<int>(). **Note**: should change StreamController sink name which handles *fetchItem()*  
- **itemsOutput**: `BehaviorSubject<Map<int, Future<ItemModel>>>()`. Therefore, we also need getter for this **stream**

<!-- NOTE: When PublishSubject or BehaviorSubject -->
<!-- What is pipe() function  -->
**IMPORTANT NOTE** in constructor:
- From above flow, **_itemsFetcher** stream will run through transformer and return a STREAM.
- And we need to transfer this STREAM result to our **_itemsOutput**. Therefore, we use **pipe()** to redirect stream.

From here, just need to modify stream getter in StreamBuilder in News tile. And some basic UI design to list each tile with title and points. We can set dividers between news therefore we should group **ListTile** and **Divider** in **Column**.