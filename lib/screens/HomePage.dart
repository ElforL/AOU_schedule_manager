import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:uni_assistant/screens/CoursesListScreen.dart';

import '../widgets/widgetsLib.dart';

class MyHomePage extends StatefulWidget {
  final UserServices userServices = MyApp.userServices;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  loadCourses() async {
    // wait then setState()
    // ignore: await_only_futures
    await widget.userServices.loadUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Lecture> lectures;
    List<Event> alerts;

    if (widget.userServices.courses.length > 0) {
      lectures = widget.userServices.getNextLectures();
      alerts = widget.userServices.getAlerts();

      var today = DateTime.now();
      var firstLecStat = lectures.length > 0 ? lectures[0].getStatus(today) : 2;
      var duration;
      if (firstLecStat == 0 && lectures[0].day == UserServices.getWeekday(today)) {
        var date =
            DateTime(today.year, today.month, today.day, lectures[0].startTime.hour, lectures[0].startTime.minute);
        duration = date.difference(today);
      } else if (firstLecStat == 1 && lectures[0].day == UserServices.getWeekday(today)) {
        var date = DateTime(today.year, today.month, today.day, lectures[0].endTime.hour, lectures[0].endTime.minute);
        duration = date.difference(today);
      }

      if (duration != null) {
        Timer(duration, () {
          setState(() {
            print('page refreshed at ${DateTime.now()}');
          });
        });
        print('TimerSet: will refresh after $duration');
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      body: widget.userServices.courses.length > 0
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                return await Future.delayed(Duration(seconds: 1));
              },
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.library_books),
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesListScreen()));
                            setState(() {});
                          })
                    ],
                  ),
                  NextLectureCard(lecture: lectures.length > 0 ? lectures[0] : null),
                  SizedBox(height: 10),
                  alerts.length > 0 ? AlertsView(alerts: alerts) : SizedBox(),
                  SizedBox(height: 10),
                  ScheduleView(
                    userServices: widget.userServices,
                    lectures: lectures.length > 0 ? lectures : widget.userServices.getWeekLectures(),
                    forNextWeek: lectures.length == 0,
                  )
                ],
              ),
            )

          // Empty Courses
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Empty :(",
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "You dont have any courses registered",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 25),
                        RaisedButton(
                          color: Color(0xffe7e7e7),
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesListScreen()));
                            setState(() {});
                          },
                          child: Text(
                            "ADD COURSES",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
