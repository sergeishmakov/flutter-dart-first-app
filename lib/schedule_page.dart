import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:first_app/apiClient.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

final storage = new FlutterSecureStorage();


class _SchedulePageState extends State<SchedulePage>{

  void fetchSchedule() async {
    final date = DateTime.now();
    final api = await createApiClient();

    print(date.millisecondsSinceEpoch);

    try {
      var response = await api.get('/StudentTimeTable?date=$date');
       print('========================');
      print(response);
      print('========================');

    } catch (e) {
      print('========================');
      print(e);
      print('========================');
    }
  }



  @override
  Widget build(BuildContext context) {
    fetchSchedule();
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
              'Schedule',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

          ],
        ),
      ),
    );
  }
}

