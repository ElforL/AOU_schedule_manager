import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/services/SettingsServices.dart';

import '../models/Course.dart';

class UserServices {
  List<Course> courses;
  DateTime semesterStart /* , semesterEnd */;

  UserServices(this.courses, [this.semesterStart]) {
    var today = DateTime.now();

    if (semesterStart == null) {
      semesterStart = today;

      for (var i = 1; semesterStart.weekday != 6; i++) {
        semesterStart = DateTime(today.year, today.month, today.day + i);
      }
    }
    if (semesterStart.weekday != 6) throw ArgumentError('Semester must start at saturday: ${semesterStart.weekday}');
  }

  // ///////////////////////////////////////////////////////////////// JSON ///////////////////////////////////////////////////////////////////

  UserServices.fromJson(Map<String, dynamic> parsedJson) {
    semesterStart = DateTime(
      parsedJson['semesterStart']['year'],
      parsedJson['semesterStart']['month'],
      parsedJson['semesterStart']['day'],
    );
    courses = (parsedJson['courses'] as List).map((i) => Course.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'semesterStart': {
        'year': semesterStart.year,
        'month': semesterStart.month,
        'day': semesterStart.day,
      },
      'courses': [for (var course in courses) course.toJson()],
    };
  }

  // //////////////// read / write //////////////////

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.json');
  }

  Future<File> writeToFile([String content]) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(content ?? jsonEncode(this));
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return null.
      return null;
    }
  }

  Future<void> loadUser() async {
    String jsonString = await readFile();
    if (jsonString == null) return;
    final jsonResponse = json.decode(jsonString);
    UserServices parsedUser = UserServices.fromJson(jsonResponse);
    courses = parsedUser.courses;
    semesterStart = parsedUser.semesterStart;
  }

  // ///////////////////////////////////////////////////////////////// Methods ///////////////////////////////////////////////////////////////////

  scheduleNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var id = await _scheduleLecturesNotifications(flutterLocalNotificationsPlugin);
    await _scheduleEventsNotifications(flutterLocalNotificationsPlugin, id);
  }

  _scheduleEventsNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, int startID) async {
    var prefs = await SharedPreferences.getInstance();
    if (!(prefs.get(Settings.notifications.toShortString()) ?? true)) return;
    if (!(prefs.get(Settings.eventsNotifications.toShortString()) ?? true)) return;

    int minutesBefore = prefs.get(Settings.minutesBeforeEventNotifications.toShortString()) ?? 10;

    tz.initializeTimeZones();
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    var events = getAllEvents();

    for (var i = 0; i < events.length; i++) {
      var id = startID + i;
      var event = events[i];
      var title = '${event.course.code} Event';
      var body = '${event.course.code} ${event.title} in $minutesBefore minutes';

      var date = tz.TZDateTime.from(event.time.add(Duration(minutes: -minutesBefore)), tz.local);
      // ensure that the date is in the future
      if (date.isBefore(DateTime.now())) return;

      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.hashCode,
        title,
        body,
        date,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'evenNoti', // channel id
            'events channel', // channel name
            channelDescription: 'channel for events notifications', // channel desc
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<int> _scheduleLecturesNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var prefs = await SharedPreferences.getInstance();
    await flutterLocalNotificationsPlugin.cancelAll();
    var i = 0;
    if (!(prefs.get(Settings.notifications.toShortString()) ?? true)) return i;
    if (!(prefs.get(Settings.lecturesNotifications.toShortString()) ?? true)) return i;

    int minutesBefore = prefs.get(Settings.minutesBeforeLecNotifications.toShortString()) ?? 10;

    tz.initializeTimeZones();
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    var lectures = getAllLectures();

    const notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'lecNoti', // channel id
        'lectures channel', // channel name
        channelDescription: 'channel for lectures notifications', // channel desc
      ),
    );

    for (i = 0; i < lectures.length; i++) {
      var lecture = lectures[i];
      var title = '${lecture.courseCode} Lecture';
      var body = '${lecture.courseCode} lecture in $minutesBefore minutes';

      if (lecture.room.isNotEmpty) {
        body = body + ' in ${lecture.room}';
      }
      var date = _getNextDateOfLec(lecture).add(Duration(minutes: -minutesBefore));
      // ensure that the date is in the future to avoid errors with notification plugin
      if (date.isBefore(DateTime.now())) date = date.add(Duration(days: 7));

      if (lecture.repeatType == RepeatType.weekly) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          '$i ${lecture.hashCode}'.hashCode, // random id
          title,
          body,
          date,
          notificationDetails,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        for (var j = 0; j < 27; j++) {
          // [date] is the next date for the lecture - [minutesBefore] disregarding the repeat type
          // So if it's even and this week is odd date could be in this week.
          //
          // So we go through 27 weeks (6 months). and check each week to see if it's odd or not ([isOdd] variable)
          // if it is odd and the lecture is odd or it's even and the lecture is even, then schedule the notification.
          var loopDate = date.add(Duration(days: 7 * j));
          final isOdd = getWeekNum(loopDate).isOdd;
          if ((isOdd && lecture.repeatType == RepeatType.odd) || (!isOdd && lecture.repeatType == RepeatType.even)) {
            await flutterLocalNotificationsPlugin.zonedSchedule(
              '$i-$j ${lecture.hashCode}'.hashCode, // random id
              title,
              body,
              date,
              notificationDetails,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            );
          }
        }
      }
    }
    return ++i;
  }

  tz.TZDateTime _getNextDateOfLec(Lecture lecture) {
    var weekday = lecture.day + 5 > 7 ? lecture.day - 2 : lecture.day + 5;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      lecture.startTime.hour,
      lecture.startTime.minute,
    );
    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  List<Event> getAllEvents() {
    List<Event> outputList = new List();

    for (var course in courses) {
      for (var event in course.events) {
        outputList.add(event);
      }
    }
    return outputList;
  }

  List<Lecture> getAllLectures() {
    List<Lecture> outputList = new List();

    for (var i = 0; i < courses.length; i++) {
      for (var lecture in courses[i].lectures) {
        outputList.add(lecture);
      }
    }
    return outputList;
  }

  List<Lecture> getNextLectures() {
    List<Lecture> outputList = new List();
    DateTime today = DateTime.now();

    for (var i = 0; i < courses.length; i++) {
      for (var lecture in courses[i].lectures) {
        if (lecture.getStatus(today) == 2) continue; // continue if the lecture passed
        if (!lecture.isOnThisWeek(getWeekNum(today)))
          continue; // or if the lecture is even and it's an odd week, or vice versa
        outputList.add(lecture);
      }
    }
    outputList.sort((a, b) => a.compareTime(b));
    return outputList;
  }

  List<Lecture> getWeekLectures() {
    List<Lecture> outputList = new List();
    DateTime today = DateTime.now();

    for (var i = 0; i < courses.length; i++) {
      for (var lecture in courses[i].lectures) {
        if (!lecture.isOnThisWeek(getWeekNum(today) + 1))
          continue; // skip if the lecture is even and it's an odd week, or vice versa
        outputList.add(lecture);
      }
    }
    outputList.sort((a, b) => a.day - b.day);
    return outputList;
  }

  List<Event> getAlerts() {
    List<Event> outputList = new List();

    for (var i = 0; i < courses.length; i++) {
      for (var event in courses[i].events) {
        var minsRem = event.remainingTime;

        if (minsRem < 21600 && minsRem >= 0) outputList.add(event);
      }
    }

    outputList.sort((a, b) => a.remainingTime - b.remainingTime);
    return outputList;
  }

  int getWeekNum(DateTime todayDate) {
    return (todayDate.difference(semesterStart).inDays ~/ 7) + 1;
  }

  static int getWeekday(DateTime date) {
    return date.weekday + 2 > 7 ? date.weekday - 5 : date.weekday + 2;
  }
}
