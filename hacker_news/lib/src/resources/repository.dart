import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../model/item_model.dart';

class Repository {
  final NewsDbProvider dbProvider = NewsDbProvider();
  final NewsApiProvider apiProvider = NewsApiProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopids();
  }

  Future<ItemModel> fetchItem(int id) async {
    var item = await dbProvider.fetchItem(id);
    if (item != null) 
      return item;
    else 
    {
      item = await apiProvider.fetchItem(id);
      dbProvider.addItem(item);
      return item;
    }
  }
}