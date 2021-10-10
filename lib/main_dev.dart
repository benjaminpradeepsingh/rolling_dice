
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'myApp.dart';

Future<void> main() async {
  FlavorConfig(
    name: "DEVELOP",
    color: Colors.red,
    location: BannerLocation.bottomStart,

  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

