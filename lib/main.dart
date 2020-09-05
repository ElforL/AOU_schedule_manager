import 'package:flutter/material.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/models/UserServices.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';

import 'constants.dart';
import 'screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static UserServices userServices;
  
  @override
  Widget build(BuildContext context) {
    List<Course> c = [
      Course('M180'),
      Course('TM111'),
      Course('TM351'),
    ];

    c[0].addLecture(Lecture(c[0].code, 'MC-5'   , 3, 0, MyTimeOfDay(hour: 20), MyTimeOfDay(hour: 22)));
    c[0].addLecture(Lecture(c[0].code, 'MC-3'   , 1, 0, MyTimeOfDay(hour: 20), MyTimeOfDay(hour: 22)));
    c[1].addLecture(Lecture(c[1].code, 'MLab-5' , 5, 2, MyTimeOfDay(hour: 18), MyTimeOfDay(hour: 20)));
    c[2].addLecture(Lecture(c[2].code, 'MC-2'   , 6, 1, MyTimeOfDay(hour: 20), MyTimeOfDay(hour: 22)));

    c[0].addEvent(Event(0, c[0].code, 'Blah blah', DateTime(2020,8,9), DateTime(2020,9,15, 16,45)));

    userServices = UserServices(new List(), DateTime(2020,9,5));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Setting background and appbar color
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),

        iconTheme: IconThemeData(
          color: kOnBackgroundColor,
        ),

      ),
      home: MyHomePage(userServices: userServices),
    );
  }
}


