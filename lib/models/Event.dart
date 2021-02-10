import 'Course.dart';

class Event {
  final Course course;
  String title;
  String description;
  DateTime time;

  Event(this.title, this.course, this.description, this.time) {
    if (title.length > 10) throw ArgumentError('Event "title" can\'t be more than 46 characters long');
    if (description.length > 46) throw ArgumentError('Event "description" can\'t be more than 46 characters long');
  }

  Event.fromJson(Map<String, dynamic> parsedJson, Course parentCourse)
      : title = parsedJson['title'],
        course = parentCourse,
        description = parsedJson['description'],
        time = DateTime.fromMillisecondsSinceEpoch(parsedJson['time']);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'time': time.millisecondsSinceEpoch,
    };
  }

  get remainingTime {
    DateTime today = DateTime.now();
    DateTime todayFixed = DateTime(today.year, today.month, today.day);
    if (time.difference(todayFixed).inDays > 0) {
      return time.difference(todayFixed).inMinutes;
    } else {
      return time.difference(today).inMinutes;
    }
  }
}
