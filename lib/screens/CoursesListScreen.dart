
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_assistant/constants.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/UserServices.dart';
import 'package:uni_assistant/screens/CourseEdit.dart';
import 'package:uni_assistant/widgets/widgetsLib.dart';

class CoursesListScreen extends StatefulWidget {
  
  const CoursesListScreen(this.userServices);

  final UserServices userServices;

  @override
  CoursesListScreenState createState() => CoursesListScreenState();
}

class CoursesListScreenState extends State<CoursesListScreen> {

  List<Widget> liist = List<Widget>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Date Pickers
          DatePicker(widget.userServices),
          SizedBox(height: 50),
        ]+
        List<Widget>.generate(widget.userServices.courses.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CourseCard(parent: this, userServices: widget.userServices ,course: widget.userServices.courses[index]),
          );
        })
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: 
            (context) => CourseEditScreen(userServices: widget.userServices, course: null)
          ));
          widget.userServices.writeToFile();
          setState(() {
            
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  
}

class DatePicker extends StatefulWidget {
  const DatePicker(this.userServices);

  final UserServices userServices;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("SEMESTER START DATE",
                style: TextStyle(
                  color: kOnBackgroundColor,
                  fontSize: 10
                ),
              ),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: '${DateFormat('dd/MM/yyyy').format(widget.userServices.semesterStart)}'
                ),
                onTap: () async{
                  widget.userServices.semesterStart = await _selectDate(context, widget.userServices.semesterStart);
                  widget.userServices.writeToFile();
                  setState(() {
                  });
                },
              )
            ],
          ),
        ),
        Expanded(child: Container()),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("SEMESTER END DATE",
                style: TextStyle(
                  color: kOnBackgroundColor,
                  fontSize: 10
                ),
              ),
              TextField(
                readOnly: true,
                controller: TextEditingController(
                  text: '${DateFormat('dd/MM/yyyy').format(widget.userServices.semesterEnd)}'
                ),
                onTap: () async{
                  widget.userServices.semesterEnd = await _selectDate(context, widget.userServices.semesterEnd);
                  setState(() {
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<DateTime> _selectDate(BuildContext context, DateTime selectedDate) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(selectedDate.year - 9),
      lastDate: DateTime(selectedDate.year + 9),
      selectableDayPredicate: (day) {
        return day.weekday == 6;
      },
      helpText: 'SELECT SEMESTER START DATE',
    );
    if (picked != null && picked != selectedDate)
      return picked;
    else
      return selectedDate;
  }
}