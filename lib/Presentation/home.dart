import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rolling_dice/Application/authentication.dart';
import 'package:rolling_dice/Models/Users.dart';
import 'package:rolling_dice/Presentation/shared/button.dart';
import 'package:rolling_dice/Services/databaseService.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var imageArray = [
    'one.png',
    'two.png',
    'three.png',
    'four.png',
    'five.png',
    'six.png'
  ];

  int randomIntForDiceOne = Random().nextInt(6);
  int score = 0;
  int count = 1;
  bool start = true;
  String name = "";
  String email = "";
  int highScore = 0;
  late User user;

  late AnimationController _animationController;
  late Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthenticationService>().getUser()!;
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    Stream<DocumentSnapshot> courseDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .snapshots();

    return Scaffold(
        body: StreamBuilder<UserProfile>(
            stream: DatabaseService.userProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                name = snapshot.data!.name ;
                email = snapshot.data!.email  ;
                highScore = snapshot.data!.highestScore;
              }

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFAFAB40),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                        ),
                      ),
                      child: Center(
                          child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                onPressed: () {

                                  context
                                      .read<AuthenticationService>()
                                      .signOut();
                                }),
                          )
                        ],
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          shadowColor: Colors.deepOrange[900],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  child: Text(
                                    'Current Score:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  child: Text(
                                    (score).toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Colors.cyan[900],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  child: Text(
                                    'High Score: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  child: Text(
                                    (highScore).toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (start)
                      DiceButton(
                          width: 200,
                          onPress: () {
                            start = false;
                            score = 0;
                            setState(() {});
                          },
                          buttonName: 'Start Game'),
                    if (!start)
                      Center(
                          child: Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.002)
                                ..rotateX(pi * _animation.value),
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/' + imageArray[randomIntForDiceOne],
                                  height: 150,
                                  width: 150,
                                ),
                              ))),
                    if (!start)
                      Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: DiceButton(
                            onPress: () {
                              changeImage();
                            },
                            buttonName: "Roll Dice ( $count )",
                            width: 200,
                          )),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/lead',
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 50),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFFB15252),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                            child: Center(
                          child: Text(
                            "Leader Board",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  void changeImage() {
    setState(() {
      if (_animationStatus == AnimationStatus.dismissed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      randomIntForDiceOne = Random().nextInt(6);
      score = score + randomIntForDiceOne + 1;
      count = count + 1;
      if (count > 10) {
        count = 1;
        //score = 0;
        start = true;
        if (highScore < score) DatabaseService.updateItem(highestScore: score);
      }
    });
  }
}
