import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github/github.dart' as github;
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/screens/CourseScreen.dart';
import 'package:uni_assistant/screens/CoursesListScreen.dart';
import 'package:uni_assistant/screens/SettingsPage.dart';
import 'package:uni_assistant/screens/SisScreen.dart';
import 'package:uni_assistant/screens/WelcomeScreen.dart';
import 'package:uni_assistant/services/GithubServices.dart';
import 'package:uni_assistant/services/SettingsServices.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgetsLib.dart';

class MyHomePage extends StatefulWidget {
  final UserServices userServices = MyApp.userServices;
  final githubServices = GithubServices();
  final settings = SettingsServices();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadCourses();

    widget.githubServices.checkNewVersion().then((release) {
      if (release != null) _showNewVersionDialog(release);
    });

    widget.settings.getSettingAsync(Settings.firstOpen).then((firstOpen) async {
      if (firstOpen) {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
        widget.settings.setSetting(Settings.firstOpen, false);
      }
    });
  }

  loadCourses() async {
    // wait then setState()
    // ignore: await_only_futures
    await widget.userServices.loadUser();
    await MyApp.sisServices.ensureLoaded();
    await checkNewSISUpdate();
    setState(() {});
  }

  checkNewSISUpdate() async {
    if (!MyApp.sisServices.isConfigured) return;

    var lastModified = await MyApp.sisServices.lastModified;
    var today = DateTime.now();
    var diff = today.difference(lastModified);

    if (diff > Duration(days: 2)) MyApp.sisServices.getNewXML();
    var foundUpdates = await MyApp.sisServices.checkCoursesForUpdate();
    if (foundUpdates)
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Courses have new upates from SIS')));
      });
  }

  _showNewVersionDialog(github.Release release) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );
    Widget downloadButton = FlatButton(
      child: Text("DOWNLOAD PAGE"),
      onPressed: () => _launchURL('https://github.com/ElforL/AOU_schedule_manager/releases'),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Newer version available"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${release.tagName}: ${release.name}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          MarkdownBody(data: release.body),
        ],
      ),
      actions: [downloadButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showUnableToOpenLinkDialog() {
    const url = 'https://github.com/ElforL/AOU_schedule_manager/releases';
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Failed"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('The app was unable to open the download page in your browser.\nPlease try again later.'),
          SizedBox(height: 10),
          Text('Or use the link to access the page manually:'),
          SizedBox(height: 10),
          Theme(
            data: ThemeData(textSelectionColor: Colors.white),
            child: SelectableText(
              url,
              style: TextStyle(color: Colors.blue),
              onTap: () {
                Clipboard.setData(new ClipboardData(text: url));
                Fluttertoast.showToast(msg: 'Link copied to clipboard');
              },
            ),
          ),
        ],
      ),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => alert,
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showUnableToOpenLinkDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Lecture> lectures;
    List<Event> alerts;

    if (widget.userServices.courses.length > 0) {
      lectures = widget.userServices.getNextLectures();
      alerts = widget.userServices.getAlerts();

      setRefreshTimer(lectures);

      return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: FittedBox(
                    child: Text(
                      'Arap Open University\nSchedule Manager',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.list_alt_rounded),
                title: Text('Courses List'),
                onLongPress: () => Fluttertoast.showToast(msg: 'Opens courses list'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => CoursesListScreen()));
                  setState(() {});
                },
              ),
              for (var course in widget.userServices.courses)
                ListTile(
                  leading: SizedBox(),
                  title: Text(course.code),
                  onLongPress: () => Fluttertoast.showToast(msg: 'Opens ${course.code} course page'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => CourseScreen(course: course)));
                    setState(() {});
                  },
                ),
              Divider(),
              ListTile(
                leading: Text('SIS'),
                title: Text('Student Information System'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SisScreen(userServices: widget.userServices)),
                  );
                  setState(() {});
                },
                trailing: MyApp.sisServices.areCoursesUpdated ? null : _buildBlueDot(),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Tutorial'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onLongPress: () => Fluttertoast.showToast(msg: 'Opens settings page'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(
                        userServices: widget.userServices,
                        githubServices: widget.githubServices,
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            return await Future.delayed(Duration(seconds: 1));
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                centerTitle: true,
                title: Text('AOU Schedule Manager'),
                leading: IconButton(
                  icon: Stack(
                    children: [
                      Icon(Icons.menu),
                      if (!MyApp.sisServices.areCoursesUpdated) _buildBlueDot(),
                    ],
                  ),
                  tooltip: 'Open Navigation Menu',
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                      child: NextLectureCard(lecture: lectures.length > 0 ? lectures[0] : null),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: alerts.length > 0 ? AlertsView(alerts: alerts) : SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: ScheduleView(
                        userServices: widget.userServices,
                        lectures: lectures.length > 0 ? lectures : widget.userServices.getWeekLectures(),
                        forNextWeek: lectures.length == 0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    // No Courses
    return EmptyCoursesPage(
      onPress: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesListScreen()));
        setState(() {});
      },
    );
  }

  Icon _buildBlueDot() {
    return Icon(
      Icons.circle,
      size: 10,
      color: Colors.blue,
    );
  }

  setRefreshTimer(lectures) {
    var today = DateTime.now();
    var firstLecStat = lectures.length > 0 ? lectures[0].getStatus(today) : 2;
    var duration;
    if (firstLecStat == 0 && lectures[0].day == UserServices.getWeekday(today)) {
      var date = DateTime(today.year, today.month, today.day, lectures[0].startTime.hour, lectures[0].startTime.minute);
      duration = date.difference(today);
    } else if (firstLecStat == 1 && lectures[0].day == UserServices.getWeekday(today)) {
      var date = DateTime(today.year, today.month, today.day, lectures[0].endTime.hour, lectures[0].endTime.minute);
      duration = date.difference(today);
    }

    if (duration != null) {
      Timer(duration, () {
        setState(() {
          print('page refreshed at ${DateTime.now()}');
        });
      });
    }
  }
}

class EmptyCoursesPage extends StatelessWidget {
  const EmptyCoursesPage({
    Key key,
    @required this.onPress,
  }) : super(key: key);

  final Future<Null> Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Empty :(",
                    style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "You dont have any courses registered",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 25),
                  RaisedButton(
                    color: Color(0xffe7e7e7),
                    onPressed: onPress,
                    child: Text(
                      "ADD COURSES",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
