import 'dart:async';
import 'package:flutter/material.dart';

import '../model/item_model.dart';
import '../blocs/stories_provider.dart';
import './loading_container.dart';

class NewsTile extends StatelessWidget {
  final int itemId;

  // Each news tile for main need a ID which is passed from Parent widget
  // to know what it show -> Pass ID in constructor
  NewsTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData)
          return LoadingContainer();
        else
          return FutureBuilder(
              future: snapshot.data[this.itemId],
              builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
                if (!itemSnapshot.hasData)
                  return LoadingContainer();
                else
                  return buildTile(context, itemSnapshot.data);
              });
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        ListTile(
          title: Text(
            item.title,
            style: TextStyle(
              color: Colors.purpleAccent[400],
              fontSize: 18.0,
            ),
          ),
          subtitle: item.score > 1
              ? Text("${item.score} points by ${item.by}")
              : Text("${item.score} point by ${item.by}"),
          trailing: Column(
            children: [
              Icon(Icons.comment, color: Colors.purpleAccent[400],),
              Text("${item.descendants}"),
            ],
          ),
          onTap: () {
            // ! Navigate to Detail screen here
            Navigator.pushNamed(context, '/${item.id}');
          },
        ),
        Divider(
          thickness: 3.0,
          height: 8.0,
        ),
      ],
    );
  }
}
