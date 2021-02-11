import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/services/GithubServices.dart';
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
  SharedPreferences prefs;
  List settingsVals;

  _setSetting(Settings setting, value) async {
    // ensure SharedPreferences isn't null
    prefs ??= await SharedPreferences.getInstance();

    // set the value according to its type
    switch (_settingsTypes[setting.index]) {
      case 'bool':
        if (value is bool) {
          settingsVals[setting.index] = value;
          await prefs.setBool(setting.toShortString(), value);
        }
        break;
      case 'int':
        if (value is int) {
          settingsVals[setting.index] = value;
          await prefs.setInt(setting.toShortString(), value);
        }
        break;
    }
  }

  /// returns the default value of a setting
  _getDefaultValue(Settings setting) {
    switch (setting) {
      case Settings.notifications:
        return true;
        break;
      case Settings.minutesBeforeLecNotifications:
        return 10;
        break;
      case Settings.lecturesNotifications:
        return true;
        break;
      case Settings.eventsNotifications:
        return true;
        break;
      case Settings.minutesBeforeEventNotifications:
        return 10;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: prefs == null ? SharedPreferences.getInstance() : Future.value(prefs),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          // if the settings are still loading, show a `CircularProgressIndicator`
          if (snapshot.connectionState != ConnectionState.done && prefs == null) {
            return Center(child: CircularProgressIndicator());
          }

          prefs = snapshot.data;
          settingsVals = [];
          // load the settings value in `settingsVals`
          // they're ordered as the `Settings` enum
          for (var setting in Settings.values) {
            var val = prefs.get(setting.toShortString());
            settingsVals.add(val);

            if (val == null) {
              val = _getDefaultValue(setting);
              _setSetting(setting, val);
              settingsVals[setting.index] = val;
            }
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
                  value: settingsVals[Settings.notifications.index],
                  onChanged: (bool value) {
                    widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                    setState(() {
                      _setSetting(Settings.notifications, value);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Lecture notifications'),
                subtitle: Text('Enable notifications for lectures'),
                enabled: settingsVals[Settings.notifications.index],
                trailing: Switch(
                  activeColor: Colors.blue,
                  value: settingsVals[Settings.lecturesNotifications.index],
                  onChanged: settingsVals[Settings.notifications.index]
                      ? (bool value) {
                          setState(() {
                            _setSetting(Settings.lecturesNotifications, value);
                          });
                        }
                      : null,
                ),
              ),

              ListTile(
                title: Text('Duration before lectures'),
                subtitle: Text('Set to ${settingsVals[Settings.minutesBeforeLecNotifications.index]} minutes'),
                enabled:
                    settingsVals[Settings.notifications.index] && settingsVals[Settings.lecturesNotifications.index],
                onTap: () async {
                  var result = await _showLecturePreTimeDialog(Settings.minutesBeforeLecNotifications);
                  if (result != null) {
                    await _setSetting(Settings.minutesBeforeLecNotifications, result);
                    widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
                  }
                  setState(() {});
                },
              ),
              ListTile(
                title: Text('Events notifications'),
                subtitle: Text('Enable notifications for events'),
                enabled: settingsVals[Settings.notifications.index],
                trailing: Switch(
                  activeColor: Colors.blue,
                  value: settingsVals[Settings.eventsNotifications.index],
                  onChanged: settingsVals[Settings.notifications.index]
                      ? (bool value) {
                          setState(() {
                            _setSetting(Settings.eventsNotifications, value);
                          });
                        }
                      : null,
                ),
              ),
              ListTile(
                title: Text('Duration before events'),
                subtitle: Text('Set to ${settingsVals[Settings.minutesBeforeEventNotifications.index]} minutes'),
                enabled: settingsVals[Settings.notifications.index] && settingsVals[Settings.eventsNotifications.index],
                onTap: () async {
                  var result = await _showLecturePreTimeDialog(Settings.minutesBeforeEventNotifications);
                  if (result != null) {
                    await _setSetting(Settings.minutesBeforeEventNotifications, result);
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
    int current = settingsVals[setting.index];

    var result = await showDialog(
      context: context,
      child: DurationDialoig(currentVal: current),
    );

    return result;
  }
}

enum Settings {
  notifications,
  lecturesNotifications,
  eventsNotifications,
  minutesBeforeLecNotifications,
  minutesBeforeEventNotifications,
}

extension ParseToString on Settings {
  String toShortString() {
    return toString().split('.').last;
  }
}

const _settingsTypes = <String>[
  'bool',
  'bool',
  'bool',
  'int',
  'int',
];
