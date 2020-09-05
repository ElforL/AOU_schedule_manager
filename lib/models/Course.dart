import 'Event.dart';
import 'Lecture.dart';

class Course{
  final String _code;
  List<Lecture> _lectures;
  List<Event> _events;

  Course(this._code){
    if(_code.length > 6) throw ArgumentError('Course code must be 6 or less characters long');
    
    _lectures = List<Lecture>();
    _events = List<Event>();
  }

  // getters
  String get code{
    return _code;
  }
  List<Lecture> get lectures{
    return _lectures;
  }
  List<Event> get events{
    return _events;
  }

  void addLecture(Lecture newLec){
    lectures.add(newLec);
  }
  void removeLecture(Lecture lecture){
    lectures.remove(lecture);
  }
  void removeLectureAt(int index){
    lectures.removeAt(index);
  }

  void addEvent(Event newEvent){
    if(events.length >= 3) throw ArgumentError("course already has 3 events");
    for (var event in events) {
      if(event.type == newEvent.type) throw ArgumentError("type already added to course: ${newEvent.type}");
    }

    events.add(newEvent);
  }
  void removeEvent(Event event){
    events.remove(event);
  }
  void removeEventAt(int index){
    events.removeAt(index);
  }
}