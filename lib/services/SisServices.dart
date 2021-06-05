import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:xml/xml.dart';

class SisServices {
  XmlDocument _xml;
  UserServices _userServices;
  List<Course> newCourses = [];

  String get _path => _userServices.sisUrl;

  bool get isLoaded => _xml != null;
  bool get isConfigured => _path != null;

  /// returns the Datetime of last modification of {localPath}/myXml.xml
  ///
  /// may throw an exception if the file isn't created
  Future<DateTime> get lastModified async => (await _localFile).lastModifiedSync();
  bool get areCoursesUpdated => newCourses.length == 0;

  SisServices(this._userServices);

  /// returns true if courses need an update
  Future<bool> checkCoursesForUpdate() async {
    await ensureLoaded();
    newCourses = compareCourses();
    return !areCoursesUpdated;
  }

  ensureLoaded() async {
    if (!isLoaded && isConfigured) {
      await _loadXML();
    }
  }

  removeSisConfig() async {
    _userServices.sisUrl = null;
    await _userServices.writeToFile();
    newCourses = [];
    _xml = null;
    await _deleteFile();
  }

  _deleteFile() async {
    (await _localFile).delete();
  }

  _loadXML() async {
    var xmlString = await readFile();
    if (xmlString == null || xmlString.isEmpty) {
      xmlString = await getNewXML();
    }
    _xml = XmlDocument.parse(xmlString);
  }

  Future<String> getNewXML() async {
    if (!isConfigured) throw Exception('SIS must be configured before getting a new XML');
    var xmlString = await _getXML(_path);
    writeToFile(xmlString);
    return xmlString;
  }

  /// returns an XML string of the registeration form of the student
  ///
  /// [path] is the url of the registeration form page from SIS
  ///
  /// throws an Exception if status code != 200
  Future<String> _getXML(String path) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = '__EVENTTARGET=CrystalReportViewer1&' +
        '__EVENTARGUMENT=%7B%22text%22%3A%22XML%22%2C+%22range%22%3A%22false%22%2C+%22tb%22%3A%22crexport%22%7D&';

    print('sending http request');
    var res = await http.post(
      Uri.parse(path),
      headers: headers,
      body: data,
    );
    print('http response recived');
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');

    return res.body;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/myXml.xml');
  }

  Future<File> writeToFile(String value) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(value);
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return null.
      print('error reading xml file');
      return null;
    }
  }

  /// returns the schedule table (Subreport4)
  ///
  /// returns null if xml is null
  ///
  /// throws an `Exception` if more than one Subreport4 were found
  XmlElement _getScheduleTable() {
    if (_xml == null) return null;
    var list = _xml.findAllElements('Subreport').where((element) => element.getAttribute('Name') == 'Subreport4');
    if (list.length == 1) return list.first;

    throw Exception('getScheduleTable() got multiple `Subreport4` (schedule reports)');
  }

  Iterable<XmlElement> _getCoursesList() {
    var table = _getScheduleTable();
    if (table == null) return null;
    return table.findElements('Details').first.findElements('Section');
  }

  List<Course> getCourses() {
    var courses = _getCoursesList();
    var res = <Course>[];
    if (courses == null) return res;
    courses.forEach((element) {
      res.add(_getCourse(element));
    });
    return res;
  }

  Course _getCourse(XmlElement course) {
    var fields = course.findElements('Field');

    var schedule, status, code;
    // var section;

    for (var field in fields) {
      var name = field.getAttribute('Name');
      switch (name) {
        case 'FULLSCHEDULE1':
          schedule = _getFieldVal(field);
          break;
        // case 'SECTIONNAME1':
        //   section = _getFieldVal(field);
        //   break;
        case 'REGISTRATIONSTATUS1':
          status = _getFieldVal(field);
          break;
        case 'COURSEPARTCODE1':
          code = _getFieldVal(field);
          break;
      }
    }

    if (status != 'Enrolled') return null;

    var resCourse = Course(code);
    var lectures = _parseScheduleString(schedule, code);
    for (var lecture in lectures) {
      resCourse.addLecture(lecture);
    }

    return resCourse;
  }

  _getFieldVal(XmlElement field) {
    return field.findElements('Value').first.innerText;
  }

  List<Lecture> _parseScheduleString(String input, String courseCode) {
    var regex = RegExp(
        r'^(.+):\s*(Weekly|[Ee]very [Tt]wo [Ww]eeks)\s*:\s*\[(\d+\/\d+\/\d+)-(\d+\/\d+\/\d+)\]\s*((?:(?:Su|Mo|Tu|We|Th|Fr|Sa);)*)\s*(\d+:\d+)\s*to\s+(\d+:\d+).*');
    var firstMatch = regex.firstMatch(input);
    var groups = [for (var i = 0; i <= firstMatch.groupCount; i++) firstMatch.group(i)];

    var room = groups[1];
    var repeat = groups[2];
    var startDate = groups[3];
    var days = groups[5].split(';');
    days.removeLast(); // removes empty element at the end
    var startTime = groups[6];
    var endTime = groups[7];

    var lectures = <Lecture>[];
    for (var day in days) {
      lectures.add(Lecture(
        courseCode,
        room,
        _getMyWeekday(day),
        _getRepeat(repeat, startDate),
        _getDayTime(startTime),
        _getDayTime(endTime),
      ));
    }

    return lectures;
  }

  MyTimeOfDay _getDayTime(String time) {
    var t = time.split(':');
    return MyTimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }

  int _getRepeat(String repeat, String startDate) {
    if (repeat.toLowerCase() == 'weekly') return 0;

    var _dateTime = DateFormat("dd/MM/yy").parse(startDate);
    _dateTime = DateTime(2000 + _dateTime.year, _dateTime.month, _dateTime.day);

    if (_dateTime == _userServices.semesterStart) // starts on the first week in semester then it's odd
      return 1;
    else
      return 2;
  }

  int _getMyWeekday(String dayCode) {
    switch (dayCode) {
      case 'Su':
        return 1;
      case 'Sa':
        return 2;
      case 'Mo':
        return 3;
      case 'Tu':
        return 4;
      case 'We':
        return 5;
      case 'Th':
        return 6;
      case 'Fr':
        return 7;
    }
    throw ArgumentError('Not a valid dayCode: $dayCode.\ndayCode can only be Mo, Tu, We, Th, Fr, Sa, or Su');
  }

  void updateCourses() {
    if (areCoursesUpdated) return;
    for (var newCourse in newCourses) {
      var matched = false;
      for (var i = 0; i < _userServices.courses.length; i++) {
        var course = _userServices.courses[i];
        if (newCourse.code == course.code) {
          matched = true;
          _userServices.courses[i] = newCourse;
          print('Updated ${course.code}');
          break;
        }
      }
      // if the new course doesn't have a previous (literally new)
      if (!matched) {
        _userServices.courses.add(newCourse);
        print('Added ${newCourse.code}');
      }
    }
    newCourses = [];
    _userServices.writeToFile();
  }

  List<Course> compareCourses() {
    var xmlCourses = getCourses();
    var courses = _userServices.courses;
    var res = <Course>[];

    for (var xmlCourse in xmlCourses) {
      var shouldAdd = true;
      for (var course in courses) {
        if (xmlCourse.code == course.code) {
          if (_doLecturesMatch(xmlCourse, course)) shouldAdd = false;
          break;
        }
      }
      if (shouldAdd) res.add(xmlCourse);
    }
    return res;
  }

  bool _doLecturesMatch(Course c1, Course c2) {
    if (c1.lectures.length != c2.lectures.length) return false;
    for (var i = 0; i < c1.lectures.length; i++) {
      if (!c1.lectures[i].equal(c2.lectures[i])) {
        return false;
      }
    }
    return true;
  }
}
