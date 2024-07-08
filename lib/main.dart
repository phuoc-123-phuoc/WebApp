import 'package:admin_uber_web_panel/dashboard/dashboard.dart';
import 'package:admin_uber_web_panel/dashboard/login.dart';
import 'package:admin_uber_web_panel/dashboard/side_navigation_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDmwe21jX4SDt5Uxco8_ZgKNQGdHW1VOwQ",
          authDomain: "todo-5c1f0.firebaseapp.com",
          projectId: "todo-5c1f0",
          storageBucket: "todo-5c1f0.appspot.com",
          messagingSenderId: "761948267066",
          appId: "1:761948267066:web:1123f42136971d11440b03"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SideNavigationDrawer(),
    );
  }
}
