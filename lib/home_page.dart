import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final storage = new FlutterSecureStorage();

checkIfAuthenticated() async {

  String accessToken = await storage.read(key: 'access_token');
  String refreshToken = await storage.read(key: 'refresh_token');
  accessToken ??= '';
  refreshToken ??= '';
  if(accessToken.length > 0 && refreshToken.length > 0) {
    //TODO add authenticate request
    await Future.delayed(Duration(seconds: 1));
    return true;
  }// could be a long running task, like a fetch from keychain
  return false;
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      if (success) {
        Navigator.pushNamed(context, '/schedule');
      } else {
        Navigator.pushNamed(context, '/sign_in');
      }
    });

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

