import 'package:flutter/material.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/models/UserServices.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';

import '../widgets/widgetsLib.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.userServices,});

  final UserServices userServices;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  loadCourses() async{
    await widget.userServices.loadCourses();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Lecture> lectures; 
    List<Event> alerts; 
    if(widget.userServices.courses.length > 0){
      lectures = widget.userServices.getNextLectures();
      alerts = widget.userServices.getAlerts();
    }

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
          child: widget.userServices.courses.length > 0? ListView(
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

              NextLectureCard(lecture: lectures.length > 0? lectures[0]: null),
              SizedBox(height: 10),
              alerts.length > 0? AlertsView(alerts: alerts): SizedBox(),
              SizedBox(height: 10),

              ScheduleView(lectures: lectures)
            ],
          )




          // Empty Courses
          :Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Empty :(",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
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
                        onPressed: (){
                          // TODO: add navigator
                          setState(() {
                            widget.userServices.courses.add(Course('TM112'));
                            widget.userServices.courses[0].addLecture(
                              Lecture('TM112', 'MC-6', 2, 0, MyTimeOfDay(hour: 20), MyTimeOfDay(hour: 22))
                            );
                            widget.userServices.writeToFile();
                          });
                        },
                        child: Text(
                          "ADD COURSES",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ), // Main View
        ),
      )
      ,
    
    );
  }
}



