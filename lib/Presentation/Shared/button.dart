import 'package:flutter/material.dart';

class DiceButton extends StatelessWidget {
  final double width;
  final Function onPress;
  final String buttonName;

  const DiceButton(
      {Key? key,
      required this.width,
      required this.onPress,
      required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0),
        )),
        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
      ),
      child: Container(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        height: 50.0,
        width: width ,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            gradient: new LinearGradient(colors: [
              Color(0xFFB15252),
              Color.fromARGB(255, 255, 136, 34),
              //  Color.fromARGB(255, 255, 177, 41),
              Color(0xFFAFAB40)
            ])),
        child: Text(
          buttonName,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
