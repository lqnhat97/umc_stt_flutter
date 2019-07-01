import 'package:flutter/material.dart';

class BlinkAnimation extends StatefulWidget {
  @override
  _BlinkAnimationState createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<BlinkAnimation>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    final CurvedAnimation curve =
    CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        ColorTween(begin: Colors.white, end: Colors.red).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return  Container(
              child:
                  Icon(
                  Icons.cancel,
                  size: 50.0,
                  color:   animation.value,
                ),

            );
          },
        );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}