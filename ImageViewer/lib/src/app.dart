// Import helper library
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

// Create our new custom widget
class AppState extends State<App> {
  // Must define a 'build' function that return
  // the widgets that *this* widget will show
  int counter = 0;

  void fetchImage() async{
    counter++;
    var response = await get('https://jsonplaceholder.typicode.com/photos/$counter');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('$counter'),
        appBar: AppBar(
          title: Text('Let\'s See Images!'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchImage,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
