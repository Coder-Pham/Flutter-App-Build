# Top News (App View)

To show all stories on Homepage *at the same time*, we might use an approach with BLOC and Stream. But there are some problems

## Data Fetching Problems

There are 2 big concerns:
- We're using asynchronous fetch data and therefore base on the size of Item, the time is required difference.
    - There may happen that 1 or 2 items take much time than others a lots.
    - This slows down app when starts up.
    - Should show at screen as soon as it's done fetching that ITEM.
- Second, the problem with API **topstories**.
    - This API returns up to 500 ids -> That means we may fetch up to 500 items at the same time.
    - But actually, we only need top of few of them (around 20).

## Solutions

With 2 big problems, we want solutions for this app:
- **1st Problem:** The solution is inside the problem. 
    - We want ItemModel be independent of any others. 
    - Our BLOC should return **Future<ItemModel>** + use **FutureBuilder** (works similar with StreamBuilder).
- **2nd Problem:** The screen can only view at most 8 at the time (maybe more with other screens)
    - We'll use **ListView.builder** to most of the work.

# ListView.builder & FutureBuilder Widget

## ListView.builder

We will start with 2 basic and required parameters:
- **itemCount**: Number of rows (or child widget) will be rendered inside **ListView**.
- **itemBuilder**: How / What widget will be rendered inside. It is *Widget Function(BuildContext, index)*:
    - @Required **context** - already mentioned in another note.
    - *index*: Row number inside ListView is going to render.

## FutureBuilder

Similar to **StreamBuilder**, but this time:
- It will wait unil it received a object
- From that object, it will try to render a widget we need.

This function, we will start with basic parameters:
- *future*: The function or The source of our needed item.
- *builder*: The widget will be re-rendered from newly item object. Take 2 arguments:
    - *context*: (BuildContext) The parent boundary of widget.
    - *snapshot*: Return object item we need.