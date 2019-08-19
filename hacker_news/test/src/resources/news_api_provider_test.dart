import 'package:hacker_news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  var rand = new Random();
  List<int> topIds = [];

  test('FetchTopIds returns a list of ids', () async {
    // setup test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      // Fake list of top ids (random)
      topIds.clear();
      for (var i = 0; i < 50; i++) {
        topIds.add(rand.nextInt(25000));
      }

      return Response(json.encode(topIds), 200);
    });

    // expect
    final ids = await newsApi.fetchTopids();

    expect(ids, topIds);
  });

  test('FetchItem returns a item model', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 2546};
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(01);
    expect(item.id, 2546);
  });
}
