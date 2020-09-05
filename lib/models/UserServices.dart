
import 'dart:convert';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';

import 'Course.dart';

class UserServices {
  List<Course> courses;
  DateTime semesterStart, semesterEnd;

  UserServices(this.courses, [this.semesterStart, this.semesterEnd]){
    if(semesterStart == null) semesterStart = DateTime.now();
    if(semesterStart == null) semesterEnd = DateTime(semesterStart.year, semesterStart.month+3);
  }

  // ///////////////////////////////////////////////////////////////// JSON ///////////////////////////////////////////////////////////////////

  UserServices.fromJson(Map<String, dynamic> parsedJson){
    semesterStart = DateTime( 
      parsedJson['semesterStart']['year'], parsedJson['semesterStart']['month'], parsedJson['semesterStart']['day']
    );
    semesterEnd = DateTime( 
      parsedJson['semesterEnd']['year'], parsedJson['semesterEnd']['month'], parsedJson['semesterEnd']['day']
    );
    courses = (parsedJson['courses'] as List).map((i) => Course.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'semesterStart':{
        'year': semesterStart.year,
        'month': semesterStart.month,
        'day': semesterStart.day,
      },
      'semesterEnd':{
        'year': semesterEnd.year,
        'month': semesterEnd.month,
        'day': semesterEnd.day,
      },
      'courses':[
        for (var course in courses) {
          course.toJson()
        }
      ]
    };
  }  


  // //////////////// read / write //////////////////
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/courses.json');
  }

  Future<File> writeToFile() async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(jsonEncode(courses));
  }
  
  Future<String> readFile() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return null.
      print(e.toString());
      return null;
    }
  }

  void loadCourses() async {
    String jsonString = await readFile();
    final jsonResponse = json.decode(jsonString);
    List<Course> parsedcourses = List<Course>.from(jsonResponse.map((i) => Course.fromJson(i)).toList());
    courses = parsedcourses;
  }
  
  // ///////////////////////////////////////////////////////////////// Methods ///////////////////////////////////////////////////////////////////

  List<Lecture> getNextLectures(){
    List<Lecture> outputList = new List();
    DateTime today = DateTime.now();

    for (var i = 0; i < courses.length; i++) {
      for (var lecture in courses[i].lectures) {
        if(lecture.getStatus(today) == 2) continue;                   // continue if the lecture passed
        if(!lecture.isOnThisWeek(today, getWeekNum(today))) continue; // or if the lecture is even and it's an odd week, or vice versa
        outputList.add(lecture);
      }
    }
    outputList.sort((a,b) => a.day - b.day);
    return outputList;
  }

  List<Event> getAlerts(){
    List<Event> outputList = new List();

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

  int getWeekNum(DateTime todayDate){
    return (todayDate.difference(semesterStart).inDays ~/ 7)+1;
  }

  static int getWeekday(DateTime date){
    return date.weekday + 2 > 7? date.weekday - 5: date.weekday + 2;
  }
}