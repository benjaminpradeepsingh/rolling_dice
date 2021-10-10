import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:provider/provider.dart';

import 'Application/authentication.dart';

import 'package:flutter/material.dart';

import 'Presentation/Login/login.dart';
import 'Presentation/Signup/signup.dart';
import 'Presentation/Splash/authenticate.dart';
import 'Presentation/Splash/splash.dart';
import 'Presentation/home.dart';
import 'Presentation/leaderBoard.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        // 3
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: FlavorBanner(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFF2661FA),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => Splash(),
            '/auth': (context) => AuthenticationWrapper(),
            '/signin': (context) => LoginScreen(),
            '/signup': (context) => SignUpScreen(),
            '/home': (context) => Home(),
            '/lead': (context) => LeaderBoard(),
          },
        ),
      ),
    );
  }
}