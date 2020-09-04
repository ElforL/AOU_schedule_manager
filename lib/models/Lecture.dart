import 'package:flutter/material.dart';

class Lecture {
  String courseCode;
  String room;
  int day;
  int repeatType;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Lecture({Key key,  @required this.courseCode, @required this.room, @required this.day, @required this.repeatType, @required this.startTime, @required this.endTime}){
    if(day > 6 || day < 1) throw ArgumentError('day number should be from 1 to 6: $day');
    if(startTime.hour > endTime.hour ) throw ArgumentError("Lecture: end time can't be before the start time: ${startTime.hour} > ${endTime.hour}");
  }





  String getDayShortcut(){
    switch (day) {
      case 1: return 'SAT';
      case 2: return 'SUN';
      case 3: return 'MON';
      case 4: return 'TUE';
      case 5: return 'WED';
      case 6: return 'THU';
      //pretty sure we can't get to here, but it's here, just in case :P
      default: throw ArgumentError('weekday number should be from 1 to 6: $day.\nthis object is faulty and can cause errors');
    }
  }
}