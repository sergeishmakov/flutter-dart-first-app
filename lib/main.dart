import 'package:first_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/profile_page.dart';
import 'package:first_app/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЭИОС',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:'/',
      routes: {
        '/': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/sign_in': (context) => SignInPage(),
      },
    );
  }
}
