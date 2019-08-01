import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> flapAnimation;
  AnimationController flapController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(
      begin: -20.0,
      end: -100.0,
    ).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

    flapController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    flapAnimation = Tween(
      begin: 0.51 * pi,
      end: 0.6 * pi,
    ).animate(
      CurvedAnimation(
        parent: flapController,
        curve: Curves.easeInOut,
      ),
    );

    flapAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        flapController.repeat(
          reverse: true,
        );
    });
    flapController.forward();

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    boxAnimation = Tween(
      begin: -0.005 * pi,
      end: 0.005 * pi,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.linear,
      ),
    );

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        boxController.repeat(reverse: true);
    });
    boxController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
              buildLeftFlap(),
              buildRightFlap(),
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
          top: catAnimation.value,
          right: 50.0,
          left: 50.0,
        );
      },
      child: Cat(),
    );
  }

  void onTap() {
    if (catAnimation.status == AnimationStatus.completed ||
        catController.status == AnimationStatus.forward) {
      catController.reverse();
      flapController.forward();
      boxController.forward();
    } else if (catController.status == AnimationStatus.dismissed ||
        catController.status == AnimationStatus.reverse) {
      catController.forward();
      flapController.reverse();
      boxController.animateTo(
        0,
        duration: Duration(milliseconds: 150),
        curve: Curves.linear,
      );
      boxController.stop();
    }
  }

  // BOX WIDGET
  Widget buildBox() {
    return AnimatedBuilder(
      animation: boxAnimation,
      child: Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          color: Colors.lime[100],
          border: Border.all(color: Colors.black, width: 2.0),
        ),
      ),
      builder: (context, child) {
        return Transform.rotate(
          child: child,
          angle: boxAnimation.value,
          alignment: Alignment.topCenter,
        );
      },
    );
  }

  // FLAP WIDGET
  Widget buildLeftFlap() {
    return Positioned(
      left: 5.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        child: Container(
          height: 13.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: Colors.lime[100],
            border: Border.all(color: Colors.black, width: 2.0),
          ),
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            angle: flapAnimation.value,
            alignment: Alignment.topLeft,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 5.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        child: Container(
          height: 13.0,
          width: 100.0,
          decoration: BoxDecoration(
            color: Colors.lime[100],
            border: Border.all(color: Colors.black, width: 2.0),
          ),
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            angle: -flapAnimation.value,
            alignment: Alignment.topRight,
          );
        },
      ),
    );
  }
}
