import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

const String LoggedInKey = 'LoggedIn';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    Tween<double> _radiusTween = Tween(begin: 100, end: 700);

    animation = _radiusTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacementNamed(
            context,
            '/auth',
          );
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final itemWidth = size.width * 1;
    final itemHeight = size.height * 0.5;
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xFFB15252),
              Color(0xFFB15252).withOpacity(.5),
              Color(0xFFAFAB40).withOpacity(.5),
            ])),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: AnimatedBuilder(
              builder: (BuildContext context, Widget? child) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/casino.png',
                    width: animation.value,
                    height: itemHeight,
                  ),
                );
              },
              animation: animation,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                    child: Text(
                  "Rolling Dice",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/rolldice.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
