import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/services/GithubServices.dart';
import 'package:uni_assistant/services/SettingsServices.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:uni_assistant/widgets/widgetsLib.dart';

class SettingsPage extends StatefulWidget {
  final UserServices userServices;
  final GithubServices githubServices;

  const SettingsPage({Key key, this.userServices, this.githubServices}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var settingsServices = SettingsServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: !settingsServices.isInitiated ? settingsServices.ensureInitiated() : Future.value(settingsServices),
        builder: (context, snapshot) {
          // if the settings are still loading, show a `CircularProgressIndicator`
          if (snapshot.connectionState != ConnectionState.done && !settingsServices.isInitiated) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              // Notifications
              ListLabel(text: 'Notifications', color: Colors.blue),
              ListTile(
                title: Text('Notifications'),
                subtitle: Text('Enable all notifications'),
                trailing: Switch(
                  activeColor: Colors.blue,
                  value: settingsServices.getSetting(Settings.notifications),
                  onChanged: (bool value) async {
                    await settingsServices.setSetting(Settings.notifications, value);
                    widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                    setState(() {});
                  },
                ),
              ),
              ListTile(
                title: Text('Lecture notifications'),
                subtitle: Text('Enable notifications for lectures'),
                enabled: settingsServices.getSetting(Settings.notifications),
                trailing: Switch(
                  activeColor: Colors.blue,
                  value: settingsServices.getSetting(Settings.lecturesNotifications),
                  onChanged: settingsServices.getSetting(Settings.notifications)
                      ? (bool value) async {
                          await settingsServices.setSetting(Settings.lecturesNotifications, value);
                          widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                          setState(() {});
                        }
                      : null,
                ),
              ),

              ListTile(
                title: Text('Duration before lectures'),
                subtitle: Text('Set to ${settingsServices.getSetting(Settings.minutesBeforeLecNotifications)} minutes'),
                enabled: settingsServices.getSetting(Settings.notifications) &&
                    settingsServices.getSetting(Settings.lecturesNotifications),
                onTap: () async {
                  var result = await _showLecturePreTimeDialog(Settings.minutesBeforeLecNotifications);
                  if (result != null) {
                    await settingsServices.setSetting(Settings.minutesBeforeLecNotifications, result);
                    widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                  }
                  setState(() {});
                },
              ),
              ListTile(
                title: Text('Events notifications'),
                subtitle: Text('Enable notifications for events'),
                enabled: settingsServices.getSetting(Settings.notifications),
                trailing: Switch(
                  activeColor: Colors.blue,
                  value: settingsServices.getSetting(Settings.eventsNotifications),
                  onChanged: settingsServices.getSetting(Settings.notifications)
                      ? (bool value) async {
                          await settingsServices.setSetting(Settings.eventsNotifications, value);
                          widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                          setState(() {});
                        }
                      : null,
                ),
              ),
              ListTile(
                title: Text('Duration before events'),
                subtitle:
                    Text('Set to ${settingsServices.getSetting(Settings.minutesBeforeEventNotifications)} minutes'),
                enabled: settingsServices.getSetting(Settings.notifications) &&
                    settingsServices.getSetting(Settings.eventsNotifications),
                onTap: () async {
                  var result = await _showLecturePreTimeDialog(Settings.minutesBeforeEventNotifications);
                  if (result != null) {
                    await settingsServices.setSetting(Settings.minutesBeforeEventNotifications, result);
                    widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                  }
                  setState(() {});
                },
              ),
              Divider(height: 20),

              // About
              ListLabel(text: 'About', color: Colors.blue),
              ListTile(
                title: Text('About AOU Schedule Manager'),
                onTap: () async {
                  var version = widget.githubServices.currentVersion ?? (await PackageInfo.fromPlatform()).version;
                  showAboutDialog(context: context, applicationVersion: version);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future _showLecturePreTimeDialog(Settings setting) async {
    int current = settingsServices.getSetting(setting);

    var result = await showDialog(
      context: context,
      builder: (_) => DurationDialoig(currentVal: current),
    );

    return result;
  }
}
