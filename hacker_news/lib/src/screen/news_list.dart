import 'package:flutter/material.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top News',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: buildList(),
    );
  }

  // Widget buildList() {
  //   return ListView.builder(
  //     itemCount: 1000,
  //     itemBuilder: (context, int index)
  //     {
  //       return FutureBuilder(
  //         future: ,
  //         builder: (context, snapshot) {
            
  //         },
  //       );
  //     },
  //   );
  // }
}
