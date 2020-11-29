import 'Course.dart';

class Event {
  //0 TMA, 1 MTA, 2 Final
  int type;
  final Course course;
  String description;
  DateTime startDateTime;
  DateTime endDateTime;

  Event(this.type, this.course, this.description, this.startDateTime, this.endDateTime) {
    if (type > 2 || type < 0) throw ArgumentError('Event type must be 0, 1, or 2');
    if (description.length > 46) throw ArgumentError('Event "included" can\'t be more than 46 characters long');
  }

  Event.fromJson(Map<String, dynamic> parsedJson, Course parentCourse)
      : type = parsedJson['type'],
        course = parentCourse,
        description = parsedJson['description'],
        startDateTime = DateTime(
            parsedJson['startDateTime']['year'],
            parsedJson['startDateTime']['month'],
            parsedJson['startDateTime']['day'],
            parsedJson['startDateTime']['hour'],
            parsedJson['startDateTime']['minute']),
        endDateTime = DateTime(parsedJson['endDateTime']['year'], parsedJson['endDateTime']['month'],
            parsedJson['endDateTime']['day'], parsedJson['endDateTime']['hour'], parsedJson['endDateTime']['minute']);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'description': description,
      'startDateTime': {
        'year': startDateTime.year,
        'month': startDateTime.month,
        'day': startDateTime.day,
        'hour': startDateTime.hour,
        'minute': startDateTime.minute,
      },
      'endDateTime': {
        'year': endDateTime.year,
        'month': endDateTime.month,
        'day': endDateTime.day,
        'hour': endDateTime.hour,
        'minute': endDateTime.minute,
      },
    };
  }

  /// null: error,
  /// 0: TMA,
  /// 1: MTA,
  /// 2: Final.
  static String getTypeName(int type) {
    return type == 0
        ? 'TMA'
        : type == 1
            ? 'MTA'
            : type == 2
                ? 'Final'
                : null;
  }

  get remainingTime {
    DateTime today = DateTime.now();
    DateTime todayFixed = DateTime(today.year, today.month, today.day);
    if (compareDate.difference(todayFixed).inDays > 0) {
      return compareDate.difference(todayFixed).inMinutes;
    } else {
      return compareDate.difference(today).inMinutes;
    }
  }

  DateTime get compareDate {
    if (type == 0)
      return endDateTime;
    else
      return startDateTime;
  }
}
