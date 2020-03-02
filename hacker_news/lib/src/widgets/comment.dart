import 'dart:async';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import '../model/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final int depth;
  final Map<int, Future<ItemModel>> cache;
  // To decode HTML escape into string text
  final unescape = new HtmlUnescape();

  Comment({this.itemId, this.cache, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cache[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: LoadingContainer(),
          );
        else {
          final children = <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: (depth + 1) * 16.0,
              ),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 3.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: ListTile(
                title: snapshot.data.by != ''
                    ? Text(
                        decodeTag(unescape.convert(snapshot.data.text)),
                        textAlign: TextAlign.justify,
                      )
                    : Text(
                        "[Deleted comment]",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                subtitle: Text(snapshot.data.by),
                contentPadding: EdgeInsets.only(
                  left: (depth + 1) * 5.0,
                  right: 16.0,
                ),
              ),
            ),
            Divider(
              thickness: 3.0,
              height: 8.0,
            ),
          ];

          snapshot.data.kids.forEach((kidId) {
            children.add(
              Comment(
                itemId: kidId,
                cache: this.cache,
                depth: this.depth + 1,
              ),
            );
          });

          return Column(
            children: children,
          );
        }
      },
    );
  }

  String decodeTag(String text) {
    return text
        .replaceAll("<p>", "\n\n")
        .replaceAll("</p>", "")
        .replaceAll("</a>", "")
        .replaceAll("</i>", "")
        .replaceAll("<i>", "")
        .replaceAll("<a href=", "");
  }
}
