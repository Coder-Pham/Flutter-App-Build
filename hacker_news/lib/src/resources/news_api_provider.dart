import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../model/item_model.dart';
import 'dart:async';
import 'repository.dart';

final String _apiurl = 'https://hacker-news.firebaseio.com/v0'; 

class NewsApiProvider implements Source{
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response =
        await client.get(_apiurl + '/topstories.json?print=pretty');
    final ids = json.decode(response.body).cast<int>();

    return ids;
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(_apiurl + '/item/$id.json');
    return ItemModel.fromJson(json.decode(response.body));
  }
}
