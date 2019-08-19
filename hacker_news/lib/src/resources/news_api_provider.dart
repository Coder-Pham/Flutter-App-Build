import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../model/item_model.dart';
import 'dart:async';

final String _apiurl = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  Client client = Client();

  Future<List<int>> fetchTopids() async {
    final response =
        await client.get(_apiurl + '/topstories.json?print=pretty');
    final ids = json.decode(response.body);

    return ids;
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(_apiurl + '/item/$id.json');
    return ItemModel.fromJson(json.decode(response.body));
  }
}
