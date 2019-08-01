import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../model/item_model.dart';

final String _apiurl = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  Client client = Client();

  fetchTopids() async {
    final response =
        await client.get(_apiurl + '/topstories.json?print=pretty');
    final ids = json.decode(response.body);

    return ids;
  }

  fetchItem(int id) async {
    final response = await client.get(_apiurl + '/item/$id.json');
    return ItemModel.fromJson(json.decode(response.body));
  }
}
