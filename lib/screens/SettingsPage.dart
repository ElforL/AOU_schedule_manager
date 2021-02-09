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
      case Settings.minutesB4LecNoti:
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
                subtitle: Text('Enable notifications for lectures'),
                trailing: Switch(
                  activeColor: Colors.blue,
                  value: settingsVals[Settings.notifications.index],
                  onChanged: (bool value) {
                    setState(() {
                      _setSetting(Settings.notifications, value);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Duration before lectures'),
                subtitle: Text('Set to ${settingsVals[Settings.minutesB4LecNoti.index]} minutes'),
                enabled: settingsVals[Settings.notifications.index],
                onTap: () async {
                  await _showLecturePreTimeDialog();
                  setState(() {});
                },
              ),
              Divider(height: 20),
              // About
              ListLabel(text: 'About', color: Colors.blue),
              ListTile(
                title: Text('About AOU Schedule Manager'),
                enabled: settingsVals[Settings.notifications.index],
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

  _showLecturePreTimeDialog() async {
    int current = settingsVals[Settings.minutesB4LecNoti.index];

    var result = await showDialog(
      context: context,
      child: DurationDialoig(currentVal: current),
    );

    if (result != null) {
      await _setSetting(Settings.minutesB4LecNoti, result);
      widget.userServices.scheduleNotifications(flutterLocalNotificationsPlugin);
    }
  }
}

enum Settings {
  notifications,
  minutesB4LecNoti,
}

extension ParseToString on Settings {
  String toShortString() {
    return toString().split('.').last;
  }
}

const _settingsTypes = <String>[
  'bool',
  'int',
];
