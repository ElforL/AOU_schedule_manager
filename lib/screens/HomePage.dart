import 'package:flutter/material.dart';
import 'package:uni_assistant/models/UserServices.dart';

import '../widgets/widgetsLib.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.userServices,});

  final UserServices userServices;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    var lectures = widget.userServices.getNextLectures();
    var alerts = widget.userServices.getAlerts();

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



