import 'package:shared_preferences/shared_preferences.dart';

class SettingsServices {
  SharedPreferences _prefs;
  bool isInitiated = false;

  SettingsServices() {
    SharedPreferences.getInstance().then((value) {
      _prefs = value;
      isInitiated = true;
    });
  }

  ensureInitiated() async {
    if (_prefs == null || !isInitiated) {
      _prefs = await SharedPreferences.getInstance();
      isInitiated = true;
    }
  }

  /// returns the value of [setting]
  ///
  /// Make sure to call `settingsServices.ensureInitiated()` before using this method
  getSetting(Settings setting) {
    if (_prefs == null)
      throw Exception(
        "SharedPreferences is null. Make sure to call settingsServices.ensureInitiated() before calling getSetting(). or, use getSettingAsync()",
      );

    // else
    var val = _prefs.get(setting.toShortString());
    if (val == null) {
      val = _getDefaultValue(setting);
      setSetting(setting, val);
    }
    return val;
  }

  Future<dynamic> getSettingAsync(Settings setting) async {
    await ensureInitiated();
    return getSetting(setting);
  }

  setSetting(Settings setting, value) async {
    // ensure SharedPreferences isn't null
    await ensureInitiated();

    // set the value according to its type
    switch (_settingsTypes[setting.index]) {
      case 'bool':
        if (value is bool) await _prefs.setBool(setting.toShortString(), value);
        break;
      case 'int':
        if (value is int) await _prefs.setInt(setting.toShortString(), value);
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
      case Settings.firstOpen:
        return true;
        break;
    }
  }

  static const _settingsTypes = <String>[
    'bool', // notifications
    'bool', // lecturesNotifications
    'bool', // eventsNotifications
    'int', // minutesBeforeLecNotifications
    'int', // minutesBeforeEventNotifications
    'bool', // firstOpen
  ];
} // SettingsServices

enum Settings {
  notifications,
  lecturesNotifications,
  eventsNotifications,
  minutesBeforeLecNotifications,
  minutesBeforeEventNotifications,
  firstOpen,
}

extension ParseToString on Settings {
  String toShortString() {
    return toString().split('.').last;
  }
}
