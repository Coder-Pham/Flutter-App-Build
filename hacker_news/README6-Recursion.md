# Recursive Fetching with Stream

## Scenario

When fetching data, we might fetch a Item that has the address of another Item. And this new Item can lead to more new others.

This is recursion fetching data.

With Stream (Subject - Rxdart), the request of Item need to be fetched is put to *StreamController.sink*. And then the StreamTransformer will do the fetching work - this is where we need a RECURSIVE FETCHING.

## Solution - ScansStreamTransformer

Start with where we put request of fetching into stream:

```dart
Function(int) get fetchComments => _commentsFetcher.sink.add;
```

And the function in Transformer after get the Item from current request, we take the link (info to next Item) put to Sink again.
As a new request in, stream and transformer will keep working for new Item:

```dart
_commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, int index) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) => fetchComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
}
```

**NOTE**: 
- Because **fetchItem()** return Future type therefore when need to take value in that. We use **.then()** to wait and extract that value.
- To recurion, we just need to make Sink take the link to new request.

# BehaviorSubject & PublishSubject

Both are SIMILAR to: **StreamController.broadcast()**

The difference between 2 Subjects:
- BehaviorSubject will always remember last ITEM which it put out.

For ex, BehaviorSubject add new Item before **listen((event) {print(event);})** is registered. The LISTENER will still print that value.
- But if PublishSubject, it will not.

# Recursive Comment Widget Builder

<!-- Explain children list with forEach() function to create children Comment widget -->
```dart
snapshot.data.kids.forEach((kidId) {
    children.add(
      Comment(
        itemId: kidId,
        cache: this.cache,
        depth: this.depth + 1,
      ),
    );
  }
);
```
Where **children** is list of Comment Widget will be render on the screen.
 
With snapshot is ItemModel of comment in cache map, then from this we can loop each **kidId** and create widget. New Comment widget will be added to list **children**.

Each widgets will be rendered separately but to make Comment in different tabs to create tree of Comment. We need to have new variable **depth**.

## Reason why init Comment can create Widget

Because this is a StatelessWidget (or StatefulWidget) therefore, when constructor bumped in, the widget will be rendered on screen.