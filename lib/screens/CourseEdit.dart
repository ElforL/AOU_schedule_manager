import 'package:flutter/material.dart';
import 'package:uni_assistant/constants.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';

import 'package:uni_assistant/widgets/widgetsLib.dart';

// ignore: must_be_immutable
class CourseEditScreen extends StatefulWidget {
  Course course;
  final UserServices userServices = MyApp.userServices;
  bool shouldAutoFocus = false;

  CourseEditScreen({Key key, this.course}) : super(key: key) {
    if (course == null) {
      shouldAutoFocus = true;
      course = new Course('M');
      userServices.courses.add(course);
    }
  }

  @override
  CourseEditScreenState createState() => CourseEditScreenState();
}

class CourseEditScreenState extends State<CourseEditScreen> {
  TextEditingController codeTfController;

  @override
  Widget build(BuildContext context) {
    codeTfController = TextEditingController(text: widget.course.code);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // COURSE CODE
          TextField(
            autofocus: widget.shouldAutoFocus,
            controller: codeTfController,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            decoration: InputDecoration(
              labelText: 'COURSE CODE',
              labelStyle: TextStyle(color: kOnBackgroundColor, fontSize: 12),
            ),
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            onChanged: (value) {
              widget.course.code = value;
            },
          ),

          // Lectures
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                  Text(
                    "Lectures",
                    style: TextStyle(
                      color: kOnBackgroundColor,
                      fontSize: 12,
                    ),
                  )
                ] +
                List<Widget>.generate(widget.course.lectures.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: LectureEditCard(lecture: widget.course.lectures[index], parent: this),
                  );
                }) +
                [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 28,
                          child: RaisedButton.icon(
                              icon: Icon(
                                Icons.add,
                                size: 20,
                              ),
                              label: Text(
                                "ADD LECTURE",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              textColor: Colors.black,
                              color: Color(0xffe7e7e7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.course.addLecture(
                                    Lecture(
                                      widget.course.code,
                                      '',
                                      1,
                                      RepeatType.weekly,
                                      MyTimeOfDay(hour: 8),
                                      MyTimeOfDay(hour: 10),
                                    ),
                                  );
                                });
                              }),
                        ),
                      ),
                    ],
                  )
                ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            // Label
            children: <Widget>[
                  Text(
                    "Events",
                    style: TextStyle(
                      color: kOnBackgroundColor,
                      fontSize: 12,
                    ),
                  )
                ] +

                // Cards
                List<Widget>.generate(widget.course.events.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: EventEditCard(event: widget.course.events[index], parent: this),
                  );
                }) +

                // Button
                [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 28,
                          child: RaisedButton.icon(
                              icon: Icon(
                                Icons.add,
                                size: 20,
                              ),
                              label: Text(
                                "ADD EVENT",
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              textColor: Colors.black,
                              color: Color(0xffe7e7e7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.course.addEvent(
                                    Event('', widget.course, '', DateTime.now()),
                                  );
                                });
                              }),
                        ),
                      ),
                    ],
                  )
                ],
          ),

          // DELETE
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 50),
            child: RaisedButton(
              color: Colors.red,
              child: Text('DELETE COURSE'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                widget.userServices.courses.remove(widget.course);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
