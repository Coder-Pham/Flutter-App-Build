import 'package:flutter/material.dart';
import 'dart:math';

class Cat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildHead();
    // return Image.network('https://i.imgur.com/QwhZRyL.png');
    // return Image.network('https://image.flaticon.com/icons/png/512/84/84811.png');
  }

  Widget buildHead() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
// Left Ear
        Positioned(
          child: Transform.rotate(
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: Colors.grey[300],
              ),
            ),
            angle: pi / 12,
          ),
          width: 50.0,
          height: 50 * sqrt(3) / 2,
          top: -5.0,
          left: -15.0,
        ),
// Right Ear
        Positioned(
          child: Transform.rotate(
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: Colors.grey[300],
              ),
            ),
            angle: -pi / 12,
          ),
          width: 50.0,
          height: 50 * sqrt(3) / 2,
          top: -5.0,
          right: -11.0,
        ),
// Body
        Positioned(
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          width: 90.0,
          height: 90.0,
          bottom: -70.0,
        ),
// Head
        SizedBox(
          width: 90.0,
          height: 90.0,
          child: Container(
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
// Left Eye
        Positioned(
          child: ClipOval(
            child: Container(
              color: Colors.black,
            ),
          ),
          width: 10.0,
          height: 20.0,
          top: 35.0,
          left: 28.0,
        ),
// Right Eye
        Positioned(
          child: ClipOval(
            child: Container(
              color: Colors.black,
            ),
          ),
          width: 10.0,
          height: 20.0,
          top: 35.0,
          right: 35.0,
        ),
// Nose
        Positioned(
          child: Transform.rotate(
            child: ClipOval(
              child: Container(
                color: Colors.grey[300],
              ),
            ),
            angle: pi * 0.5,
          ),
          width: 10.0,
          height: 15.0,
          top: 50,
          right: 50.0,
        ),
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
