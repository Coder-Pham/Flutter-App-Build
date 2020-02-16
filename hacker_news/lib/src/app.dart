import 'package:flutter/material.dart';
import 'screen/news_list.dart';
import 'blocs/stories_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: MaterialApp(
        title: 'Hacker News',
        theme: ThemeData.dark(),
        home: NewsList(),
      ),
    );
  }
}
