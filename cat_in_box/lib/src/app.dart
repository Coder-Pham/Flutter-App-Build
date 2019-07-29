import 'package:flutter/material.dart';
import 'screen/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}
