import 'package:flutter/material.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/models/UserServices.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';
import 'package:uni_assistant/screens/CoursesListScreen.dart';

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

      //TODO remove center
      body: Center(
        // Main View
        child: widget.userServices.courses.length > 0? ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.library_books),
                  onPressed: () async{
                    await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CoursesListScreen(widget.userServices))
                    );
                    setState(() {
                      
                    });
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
                      onPressed: () async{
                        await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CoursesListScreen(widget.userServices))
                        );
                        setState(() {
                          
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
        ),
      )
      ,
    
    );
  }
}



