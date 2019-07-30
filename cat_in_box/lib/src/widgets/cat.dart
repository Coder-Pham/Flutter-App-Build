import 'package:flutter/material.dart';

class Cat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network('https://i.imgur.com/QwhZRyL.png');
    // return Image.network('https://image.flaticon.com/icons/png/512/84/84811.png');
  }

  Widget buildHead() {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                ),
              ],
            ),
          ),
        ),
        new Positioned(
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          top: 45.0,
          left: 85.0,
        ),
        new Positioned(
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          top: 45.0,
          right: 85.0,
        ),
      ],
    );
  }
}
