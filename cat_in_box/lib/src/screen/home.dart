import 'package:flutter/material.dart';
import '../widgets/cat.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    catAnimation = Tween(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Boop In a Box'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // CAT WIDGET - HELPER
  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: -catAnimation.value + 15,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  void onTap() {
    if (catAnimation.status == AnimationStatus.completed ||
        catController.status == AnimationStatus.forward)
      catController.reverse();
    else if (catController.status == AnimationStatus.dismissed ||
        catController.status == AnimationStatus.reverse)
      catController.forward();
  }

  // BOX WIDGET
  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.lime[100],
    );
  }
}
