import 'package:flutter/material.dart';
import 'package:rolling_dice/Presentation/CustomShape/shapes.dart';

class Background extends StatelessWidget {
  final Widget child;
  final double headerHeight;

  const Background({
    Key? key,
    required this.child,
    this.headerHeight = 250,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: headerHeight,
                ),
                painter: HeaderPainter(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
                painter: FooterPainter(),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
