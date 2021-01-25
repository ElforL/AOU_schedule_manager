import 'package:flutter/material.dart';
import 'package:uni_assistant/constants.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:uni_assistant/screens/CourseEdit.dart';
import 'package:uni_assistant/widgets/widgetsLib.dart';

class CourseScreen extends StatefulWidget {
  final Course course;
  final UserServices userServices = MyApp.userServices;

  CourseScreen({Key key, this.course}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 20,
              ),
              onPressed: () async {
                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CourseEditScreen(course: widget.course)));
                widget.userServices.writeToFile();
                if (!widget.userServices.courses.contains(widget.course)) Navigator.pop(context);
                for (var i = 0; i < widget.course.lectures.length; i++) {
                  widget.course.lectures[i].courseCode = widget.course.code;
                }
                await widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Course code
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.course,
                child: Material(
                  color: kGrayCardColor,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                    child: Center(
                      child: Text(
                        widget.course.code,
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              'Lectures',
              style: TextStyle(
                color: kOnBackgroundColor,
              ),
            ),
            SizedBox(height: 15),
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.course.lectures.length > 0
                    ? List<Widget>.generate(widget.course.lectures.length, (index) {
                        return LectureCard(userServices: widget.userServices, lecture: widget.course.lectures[index]);
                      })

                    // Empty
                    : [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'No Lectures',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ]),
          ]),

          widget.course.events.length > 0
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Dates',
                    style: TextStyle(
                      color: kOnBackgroundColor,
                    ),
                  ),
                  Column(
                    children: List<Widget>.generate(widget.course.events.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: EventCard(event: widget.course.events[index]),
                      );
                    }),
                  ),
                ])
              : SizedBox(),
        ],
      ),
    );
  }
}
