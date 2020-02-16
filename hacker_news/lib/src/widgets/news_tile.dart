import 'dart:async';
import 'package:flutter/material.dart';
import '../model/item_model.dart';
import '../blocs/stories_provider.dart';

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
          return Text('Still loading');
        else
          return FutureBuilder(
            future: snapshot.data[this.itemId],
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData)
                return Text("Still loading: $itemId");
              return Text(itemSnapshot.data.title);
            }
          );
      },
    );
  }
}
