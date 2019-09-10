import 'package:flutter/material.dart';
import 'screen/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData.dark(),
      home: NewsList(),
    );
  }
}
