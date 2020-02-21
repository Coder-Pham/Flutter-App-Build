# View-Performance Problem

Currently, with the **ListView.builder()** without **ListTile()** the engine will fetch around 50 items. But in reality, it only renders 6-8 items at a time because ListTiles stack on each others. So we're aiming to reduce the number of unshow fetching items.

Therefore, solution is that every tiles have a FIXED height so that that engine knows how many tiles is needed to render and fetch with that number.

## Solution - Standin Container

We can re-render ListTile with grey and empty items (like Youtube web) by **LoadingContainer**

# Top Item Isn't Up-to-date (scores and comments)

The problem comes from **bloc.fetchItem()** in *news_list.dart* where new Top Item only being fetch by ONCE ONLY from API, therefore no update for each items. Because if Item is found already in DB then it won't fetch again (condition not null in first loop).

So we somehow make it automatically or manually fetching from API:
- Set time of caching for each items, after that time items should be re-fetched.
- Pull to update (manual method)

## Solution - Pull to refresh

https://api.flutter.dev/flutter/material/RefreshIndicator-class.html

Quite straight-forward method with Flutter. Use this widget with 2 important parameters:
- *child*: The widget is needed to pull-refresh
- *onRefresh RefreshCallback* function: return Future  must complete when the refresh is done. 

## OOP Model

```
RefreshIndicator    -->   StoriesBloc -->  Repository  --> DB_Provider
```

## Note - Future in Dart world

In **onRefresh** function, it wants to receive the *Future* and when it resolves then the function can be finished. So back to **clearCache()** function in the **repository.dart**:

```dart
clearCache() async {
    for (var cache in caches)
      await cache.clear();
}
```

Eventhough, this function doesn't have any return statement but it will be marked as return **Future** object, more precise is return **`Future<void>`**. Because of **async/await** syntax

And now go back to root, when **StoriesBloc** reach to return **clearCache()**, it will return **Future** object. Therefore when call **clearCache()** of BLOC in *onRefresh*, there will exist a Future object which needs to resolve.