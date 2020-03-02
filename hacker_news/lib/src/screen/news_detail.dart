import 'dart:async';
import 'package:flutter/material.dart';

import '../model/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News Details",
          style: TextStyle(
            color: Colors.purpleAccent[400],
            fontSize: 24.0,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.purpleAccent[400],
        ),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.comments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final itemFuture = snapshot.data[this.itemId];
          return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
              if (!itemSnapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                // return buildTile(itemSnapshot.data);
                return buildList(itemSnapshot.data, snapshot.data);
            },
          );
        }
      },
    );
  }

  Widget buildTile(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(10.0),
      // alignment: Alignment.topCenter,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> cache) {
    final commentsList = item.kids
        .map((kidId) => Comment(
              itemId: kidId,
              cache: cache,
              depth: 0,
            ))
        .toList();

    return ListView(
      children: <Widget>[
        buildTile(item),
        ...commentsList,
      ],
    );
  }
}
