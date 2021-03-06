import 'package:flutter/material.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/screens/sisConfigScreen.dart';
import 'package:uni_assistant/services/SisServices.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:url_launcher/url_launcher.dart';

class SisScreen extends StatefulWidget {
  final UserServices userServices;

  SisScreen({Key key, @required this.userServices}) : super(key: key);

  @override
  _SisScreenState createState() => _SisScreenState();
}

class _SisScreenState extends State<SisScreen> {
  SisServices get sisServices => MyApp.sisServices;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Can not launch url: $url');
    }
  }

  ensureSis() async {
    if (sisServices.isConfigured) {
      var bLoaded = sisServices.isLoaded;
      var check = sisServices.areCoursesUpdated;
      var foundUpdates = await sisServices.checkCoursesForUpdate();
      if (check == foundUpdates || sisServices.isLoaded != bLoaded) setState(() {});
    }
  }

  _showUpdateDialog() async {
    var dialog = AlertDialog(
      title: Text('Update Courses'),
      content: Text('Are you sure you want to update?'),
      actions: [
        TextButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('UPDATE'),
          onPressed: () {
            sisServices.updateCourses();
            Navigator.pop(context);
          },
        ),
      ],
    );
    await showDialog(context: context, builder: (_) => dialog);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ensureSis();
    return Scaffold(
      appBar: AppBar(
        title: Text('SIS'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'More options',
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: ListTile(
                  title: Text('Configure'),
                  onTap: () async {
                    await _gotoConfigScreen();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              (sisServices.isConfigured ? '' : 'NOT ') + 'CONFIGURED',
              style: Theme.of(context).textTheme.headline4.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sisServices.isConfigured ? Colors.green : Colors.red,
                    ),
                  ),
            ),
            if (sisServices.isConfigured && !sisServices.isLoaded) Text('Loading files...'),
            if (sisServices.isLoaded)
              Column(
                children: [
                  Text(
                    'Courses ' + (sisServices.areCoursesUpdated ? 'up to date' : 'are outdated'),
                    style: Theme.of(context).textTheme.headline6.apply(
                          color: sisServices.areCoursesUpdated ? Colors.green : Colors.red,
                        ),
                  ),
                  if (!sisServices.areCoursesUpdated)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('Outdated courses:'),
                    ),
                  if (!sisServices.areCoursesUpdated)
                    for (var course in sisServices.newCourses)
                      Column(
                        children: [
                          Text('${course.code}:'),
                          for (var lecture in course.lectures)
                            Text(
                              lecture.toString().replaceFirst('${course.code} lecture:', ''),
                              style: Theme.of(context).textTheme.caption,
                            ),
                        ],
                      ),
                  if (!sisServices.areCoursesUpdated)
                    ElevatedButton(
                      child: Text('UPDATE'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        _showUpdateDialog();
                      },
                    ),
                ],
              ),
            Spacer(),
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!sisServices.isConfigured)
                    ElevatedButton(
                      child: FittedBox(child: Text('CONFIGURE')),
                      onPressed: () async {
                        await _gotoConfigScreen();
                        setState(() {});
                      },
                    ),
                  if (sisServices.isConfigured)
                    ElevatedButton(
                      child: FittedBox(child: Text('CHECK FOR UPDATES')),
                      onPressed: () async {
                        showScaffold('Checking for updates');
                        await sisServices.getNewXML();
                        var foundUpdates = await sisServices.checkCoursesForUpdate();
                        setState(() {
                          showScaffold(foundUpdates ? 'New updates available' : 'You are up to date');
                        });
                      },
                    ),
                  if (sisServices.isConfigured)
                    ElevatedButton(
                      child: FittedBox(child: Text('OPEN REGISTERATION FORM')),
                      onPressed: () {
                        _launchURL(widget.userServices.sisUrl);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showScaffold(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  _gotoConfigScreen() async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SisConfigScreen(
          userServices: widget.userServices,
          sisServices: sisServices,
        ),
      ),
    );
  }
}
