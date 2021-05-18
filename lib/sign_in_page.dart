import 'package:flutter/material.dart';
import 'form.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo.jpg', width: 50, height: 50 ),
        title: Text('Вход'),
        backgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.blueGrey,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: MyCustomForm()
      ),
    );
  }
}