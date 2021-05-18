import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:first_app/apiClient.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

final storage = new FlutterSecureStorage();

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin{
  var data = {};
  var _tabController ;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    fetchSchedule(DateTime.now());
  }


  fetchSchedule(date) async {
    var stringToday = date.toIso8601String();

    setState(() {
      isLoading = true;
    });
    final api = await createApiClient();

    Response response = await api.get('/StudentTimeTable?date=$stringToday');

    if(response.statusCode == 200){
      setState(() {
        data = response?.data[0];
        isLoading = false;
      });
    }else{
      isLoading = false;
    }
  }


  @override
  Widget build(BuildContext context)  {
    return content();
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Refer step 1
      firstDate: DateTime(_selectedDate.year - 6),
      lastDate: DateTime(_selectedDate.year + 6),
    );
    if (picked != null && picked != _selectedDate)
      fetchSchedule(picked);
      setState(() {
        _selectedDate = picked;
      });
  }

  Widget content(){
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: Image.asset('assets/logo.jpg', width: 50, height: 50 ),
              title: Text('Расписание'),
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
            body: getBody()
        )
    );
  }

  Widget getBody(){
    if(data == null || isLoading){
      return Center(child: CircularProgressIndicator());
    }
    final facultyName = data['FacultyName'];
    final groupNumber = data['Group'];
    final baseLessons = data['TimeTable']['Lessons'];
    final maxLessonNumber = (baseLessons as List).map<int>((e) => e['Number']).reduce(max);
    final lessons = [];
    for (int i = 0; i <= maxLessonNumber; i++){
      lessons.add({ 'Number': i, 'SubgroupCount': 0, 'Disciplines': []});
    }
    baseLessons.forEach((e) => lessons[e['Number']] = e);
    lessons.removeAt(0);

    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$facultyName, $groupNumber группа', style: TextStyle(fontSize: 16)),

            TabBar(
              labelColor: Colors.blueGrey,
              tabs: [
                Tab(text: "День"),
                Tab(text: "Неделя"),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Text("Дата:", style: TextStyle(fontSize: 16))
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(

                          onPressed: () => {
                            _selectDate(context)
                          }, // Refer step 3
                          child: Text(DateFormat.yMMMMEEEEd().format(_selectedDate),
                            style: TextStyle(color: Colors.black87),
                          ),
                          style: ButtonStyle(
                              alignment: Alignment.centerLeft,
                              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              backgroundColor: MaterialStateProperty.all<Color>(ThemeData().scaffoldBackgroundColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side: BorderSide(color: Colors.grey)
                                  )
                              )
                            ),
                          ),
                      ),
                      Table(
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(6),
                        },
                        children: lessons
                            .map((lesson) => TableRow(children: [
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(lesson['Number'].toString())
                                    )
                                ),
                              ),
                              Column(
                                children: (lesson['Disciplines'] as List).map((discipline) =>
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(discipline['Title'])
                                    )
                                ).toList()
                              ),
                              // you can have more properties of course
                            ]))
                            .toList()
                      )
                    ]
                  ),
                  Text('Week')
                ],
                controller: _tabController,
              ),
            ),
        ])
    );
  }
}



