
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';

import 'Course.dart';

class UserServices {
  UserServices(this.courses, [this.semesterStart]){
    if(semesterStart == null) semesterStart = DateTime.now();
    semesterEnd = DateTime(semesterStart.year, semesterStart.month+3);
  }
  
  List<Course> courses;
  DateTime semesterStart, semesterEnd;

  int getWeekNum(DateTime todayDate){
    return (todayDate.difference(semesterStart).inDays ~/ 7)+1;
  }

  List<Lecture> getNextLectures(){
    List<Lecture> outputList = new List();
    DateTime today = DateTime.now();

    for (var i = 0; i < courses.length; i++) {
      for (var lecture in courses[i].lectures) {                      // continue if
        if(lecture.getStatus(today) == 2) continue;                 // if the lecture passed
        if(!lecture.isOnThisWeek(today, getWeekNum(today))) continue; // if the lecture is even and it's an odd week, and vice versa
        outputList.add(lecture);
      }
    }
    outputList.sort((a,b) => a.day - b.day);
    return outputList;
  }

  List<Event> getAlerts(){
    List<Event> outputList = new List();
    DateTime compareDate;

    for (var i = 0; i < courses.length; i++) {
      for (var event in courses[i].events) {
        var minsRem = event.remainingTime;

        if(minsRem < 21600 && minsRem >= 0)
          outputList.add(event);
      }
    }

    outputList.sort((a,b) => a.remainingTime - b.remainingTime);
    return outputList;
  }

  static int getWeekday(DateTime date){
    return date.weekday + 2 > 7? date.weekday - 5: date.weekday + 2;
  }
}