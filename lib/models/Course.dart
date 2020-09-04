


import 'Event.dart';
import 'Lecture.dart';

class Course{
  final String code;
  var lectures;
  var events;

  Course(this.code){
    if(code.length > 6) throw ArgumentError('Course code must be 6 or less characters long');
    
    lectures = List<Lecture>();
    events = List<Event>();
  }
}