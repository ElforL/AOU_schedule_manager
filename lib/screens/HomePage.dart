import 'package:flutter/material.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';

import '../widgets/widgetsLib.dart';
import '../models/Lecture.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.coursesList,});

  var coursesList;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var theLec = Lecture(courseCode: 'TM112', room: 'MLab-6', day: 1, repeatType: 0, startTime: MyTimeOfDay(hour: 20, minute: 0), endTime: MyTimeOfDay(hour: 22, minute: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          // Main View
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.list),
                    onPressed: (){
                      // TODO take to courses screen
                    }
                  )
                ],
              ),

              NextLectureCard(status: 2, lecture: theLec),
              SizedBox(height: 10),
              // TODO: add alerts count check for alerts widget
              true? AlertsView(): SizedBox(),
              SizedBox(height: 10),

              ScheduleView()
            ],
          ), // Main View
        ),
      ),
    );
  }
}



