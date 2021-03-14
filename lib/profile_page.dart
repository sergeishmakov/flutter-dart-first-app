import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final storage = new FlutterSecureStorage();

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo.jpg', width: 50, height: 50 ),
        title: Text('ЭИОС'),
        backgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.blueGrey,
        ),
        actions: <Widget> [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.blue,
            tooltip: 'Log out',
            onPressed: () async {
              await storage.delete(key: 'access_token');
              await storage.delete(key: 'refresh_token');
              Navigator.pushNamed(context, '/sign_in');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

          ],
        ),
      ),
    );
  }
}

