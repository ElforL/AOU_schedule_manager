import 'package:uni_assistant/services/UserServices.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';

class Lecture {
  String courseCode;
  String _room;
  int _day;
  RepeatType _repeatType;
  MyTimeOfDay _startTime;
  MyTimeOfDay _endTime;

  Lecture(this.courseCode, this._room, this._day, this._repeatType, this._startTime, this._endTime) {
    if (day > 6 || day < 1) throw ArgumentError('day number should be from 1 to 6: $day');
    if (_room.length > 10) throw ArgumentError('room can\'t be more than 10 characters long');
    if (startTime.hour > endTime.hour)
      throw ArgumentError("Lecture: end time can't be before the start time: ${startTime.hour} > ${endTime.hour}");
  }

  Lecture.fromJson(Map<String, dynamic> parsedJson)
      : courseCode = parsedJson['code'],
        _room = parsedJson['room'],
        _day = parsedJson['day'],
        _repeatType = parsedJson['repeatType'] == 0
            ? RepeatType.weekly
            : parsedJson['repeatType'] == 1
                ? RepeatType.odd
                : RepeatType.even,
        _startTime = MyTimeOfDay.fromJson(parsedJson['startTime']),
        _endTime = MyTimeOfDay.fromJson(parsedJson['endTime']);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': courseCode,
      'room': room,
      'day': day,
      'repeatType': repeatType == RepeatType.weekly
          ? 0
          : repeatType == RepeatType.odd
              ? 1
              : 2,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
    };
  }

  String get room {
    if (_room.length > 10) throw ArgumentError('room can\'t be more than 10 characters long');
    return _room;
  }

  int get day {
    return _day;
  }

  /// 0 weekly, 1 odd, 2 even
  RepeatType get repeatType {
    return _repeatType;
  }

  MyTimeOfDay get startTime {
    return _startTime;
  }

  MyTimeOfDay get endTime {
    return _endTime;
  }

  set room(String newRoom) {
    _room = newRoom;
  }

  set day(int newDay) {
    if (newDay > 6 || newDay < 1) throw ArgumentError('day number should be from 1 to 6: $newDay');
    _day = newDay;
  }

  set repeatType(RepeatType newRepeat) {
    _repeatType = newRepeat;
  }

  set startTime(MyTimeOfDay newStart) {
    if (!(newStart < endTime))
      throw ArgumentError("Lecture: end time can't be before the start time: ${startTime.hour} > ${endTime.hour}");
    _startTime = newStart;
  }

  set endTime(MyTimeOfDay newEnd) {
    if (!(startTime < newEnd))
      throw ArgumentError("Lecture: end time can't be before the start time: ${startTime.hour} > ${endTime.hour}");
    _endTime = newEnd;
  }

  bool equal(Lecture lec) {
    if (this.courseCode != lec.courseCode) return false;
    if (this.room != lec.room) return false;
    if (this.day != lec.day) return false;
    if (this.repeatType != lec.repeatType) return false;
    if (this.startTime != lec.startTime) return false;
    if (this.endTime != lec.endTime) return false;

    return true;
  }

  /// returns and integer depending on it's time status
  ///
  /// 0 for 'coming up',
  /// 1 for 'going on',
  /// 2 for 'passed'.
  int getStatus(DateTime today) {
    DateTime compareStartTime = DateTime(today.year, today.month, today.day, startTime.hour, startTime.minute);
    DateTime compareEndTime = DateTime(today.year, today.month, today.day, endTime.hour, endTime.minute);

    // if the day already passed
    if (day < UserServices.getWeekday(today)) {
      return 2;
    } else if (day == UserServices.getWeekday(today)) {
      if (today.difference(compareStartTime).inMinutes < 0) {
        return 0;
      } else {
        if (today.difference(compareEndTime).inMinutes < 0) {
          return 1;
        } else {
          return 2;
        }
      }
    } else {
      return 0;
    }
  }

  bool isOnThisWeek(int weekNum) {
    if (repeatType == RepeatType.weekly) return true;
    if ((repeatType == RepeatType.odd && weekNum.isOdd) || repeatType == RepeatType.even && weekNum.isEven) {
      return true;
    } else {
      return false;
    }
  }

  String getDayShortcut() {
    switch (day) {
      case 1:
        return 'SAT';
      case 2:
        return 'SUN';
      case 3:
        return 'MON';
      case 4:
        return 'TUE';
      case 5:
        return 'WED';
      case 6:
        return 'THU';
      //pretty sure we can't get to here, but it's here, just in case :P
      default:
        throw ArgumentError('weekday number should be from 1 to 6: $day.\nthis object is faulty and can cause errors');
    }
  }

  String getDayName([int day]) {
    if (day == null) day = _day;
    switch (day) {
      case 1:
        return 'Saturday';
      case 2:
        return 'Sunday';
      case 3:
        return 'Monday';
      case 4:
        return 'Tuesday';
      case 5:
        return 'Wednesday';
      case 6:
        return 'Thursday';
      //pretty sure we can't get to here, but it's here, just in case :P
      default:
        throw ArgumentError('weekday number should be from 1 to 6: $day.\nthis object is faulty and can cause errors');
    }
  }

  int compareTime(Lecture other) {
    if (this.day < other.day) {
      // [other] is after
      return -1;
    } else if (this.day > other.day) {
      // [other] is before
      return 1;
    } else {
      // both on the same day
      return MyTimeOfDay.compare(this.startTime, other.startTime);
    }
  }

  @override
  String toString() {
    var res = '$courseCode lecture: ';
    res += '$room: ';
    res += getDayName(_day);
    switch (_repeatType) {
      case RepeatType.weekly:
        res += ' weekly ';
        break;
      case RepeatType.odd:
        res += ' on odd weeks ';
        break;
      default:
        res += ' on even weeks ';
        break;
    }

    res += '${startTime.to24hString()} - ${endTime.to24hString()}';

    return res;
  }
}

enum RepeatType {
  weekly,
  even,
  odd,
}
