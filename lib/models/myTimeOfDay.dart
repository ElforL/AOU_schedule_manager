import 'package:flutter/material.dart';

class MyTimeOfDay extends TimeOfDay {
  MyTimeOfDay({int hour = 0, int minute = 0}) : super(hour: hour, minute: minute);

  MyTimeOfDay.fromJson(Map<String, dynamic> parsedJson)
      : super(
          hour: parsedJson['hour'],
          minute: parsedJson['minute'],
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'hour': hour,
      'minute': minute,
    };
  }

  String toString() {
    var hh = this.hourOfPeriod.toString().padLeft(2, '0');
    var mm = this.minute.toString().padLeft(2, '0');
    var a = this.period.index == 0 ? 'AM' : 'PM';

    return '$hh:$mm $a';
  }

  bool operator <(MyTimeOfDay other) {
    if (this.hour < other.hour) {
      return true;
    } else if (this.hour > other.hour) {
      return false;
    } else {
      return this.minute < other.minute;
    }
  }

  /// * returns 1 if t1 is earlier
  /// * returns -1 if t2 is earlier
  /// * returns 0 if both are the same
  static int compare(TimeOfDay t1, TimeOfDay t2) {
    if (t1.hour > t2.hour) {
      return -1;
    } else if (t1.hour < t2.hour) {
      return 1;
    } else {
      // same hour
      if (t1.minute > t2.minute) {
        return -1;
      } else if (t1.minute < t2.minute) {
        return 1;
      }
    }
    return 0;
  }
}
