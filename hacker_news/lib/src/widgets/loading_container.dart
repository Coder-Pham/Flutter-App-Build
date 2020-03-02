import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Container(
            color: Colors.blueGrey,
            height: 24.0,
            width: 150.0,
            margin: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
          ),
          subtitle: Container(
            color: Colors.blueGrey,
            height: 24.0,
            width: 25.0,
            margin: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
          ),
        ),
        Divider(
          thickness: 3.0,
          height: 8.0,
        ),
      ],
    );
  }
}
