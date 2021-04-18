import 'package:first_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:first_app/profile_page.dart';
import 'package:first_app/sign_in_page.dart';
import 'package:first_app/schedule_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  await DotEnv.load(fileName: ".env");
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
        '/schedule': (context) => SchedulePage(),
        '/sign_in': (context) => SignInPage(),
      },
    );
  }
}
