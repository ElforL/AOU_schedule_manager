import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_assistant/main.dart';
import 'package:uni_assistant/services/UserServices.dart';

class SettingsPage extends StatefulWidget {
  final UserServices userServices;

  const SettingsPage({Key key, this.userServices}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;
  List settingsVals;

  _setSetting(Settings setting, value) async {
    prefs ??= await SharedPreferences.getInstance();

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
          if (snapshot.connectionState != ConnectionState.done && prefs == null) {
            return Center(child: CircularProgressIndicator());
          }

          prefs = snapshot.data;
          settingsVals = [];
          for (var setting in Settings.values) {
            var val = prefs.get(setting.toShortString());
            settingsVals.add(val);

            if (val == null) {
              val = _getDefaultValue(setting);
              _setSetting(setting, val);
            }
          }

          return ListView(
            children: [
              // Notifications
              ListTile(
                title: Text('Notifications'),
                subtitle: Text('Enable notifications'),
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
              ListTile(
                title: Text('About AOU Schedule Manager'),
                enabled: settingsVals[Settings.notifications.index],
                onTap: () => showAboutDialog(
                  context: context,
                  applicationVersion: '1.8.1',
                ),
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

class DurationDialoig extends StatefulWidget {
  final int currentVal;

  const DurationDialoig({Key key, this.currentVal}) : super(key: key);

  @override
  _DurationDialoigState createState() => _DurationDialoigState(currentVal);
}

class _DurationDialoigState extends State<DurationDialoig> {
  _DurationDialoigState(this.currentVal);

  int currentVal;

  Widget okButton() => FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context, currentVal);
        },
      );

  Widget cancelButton() => FlatButton(
        child: Text("CANCEL"),
        onPressed: () => Navigator.pop(context),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose a new value'),
      actions: [cancelButton(), okButton()],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 6; i++)
            RadioListTile(
              title: Text('${10 * i} minutes'),
              value: 10 * i,
              groupValue: currentVal,
              onChanged: (newVal) {
                setState(() {
                  currentVal = newVal;
                });
              },
            ),
        ],
      ),
    );
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
