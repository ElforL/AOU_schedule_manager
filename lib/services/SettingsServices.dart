import 'package:shared_preferences/shared_preferences.dart';

class SettingsServices {
  SharedPreferences _prefs;
  List<dynamic> _settingsVals = [];
  bool isInitiated = false;

  SettingsServices() {
    SharedPreferences.getInstance().then((value) {
      // _prefs
      _prefs = value;

      _loadSettings();

      isInitiated = true;
    });
  }

  _loadSettings() {
    // load the settings value in `settingsVals`
    // they're ordered as the `Settings` enum
    for (var setting in Settings.values) {
      var val = _prefs.get(setting.toShortString());
      _settingsVals.add(val);

      if (val == null) {
        val = _getDefaultValue(setting);
        setSetting(setting, val);
        _settingsVals[setting.index] = val;
      }
    }
  }

  ensureInitiated() async {
    if (_prefs == null || !isInitiated) {
      _prefs = await SharedPreferences.getInstance();
      _loadSettings();
      isInitiated = true;
    }
  }

  /// returns the value of [setting]
  ///
  /// Make sure to call `settingsServices.ensureInitiated()` before using this method
  getSetting(Settings setting) {
    if (_prefs == null)
      throw Exception(
        "SharedPreferences is null. Make sure to call settingsServices.ensureInitiated() before calling settingsServices.getSetting()",
      );

    // else
    return _settingsVals[setting.index];
  }

  Future<dynamic> getSettingAsync(Settings setting) async {
    await ensureInitiated();
    return _settingsVals[setting.index];
  }

  setSetting(Settings setting, value) async {
    // ensure SharedPreferences isn't null
    await ensureInitiated();

    // set the value according to its type
    switch (_settingsTypes[setting.index]) {
      case 'bool':
        if (value is bool) {
          _settingsVals[setting.index] = value;
          await _prefs.setBool(setting.toShortString(), value);
        }
        break;
      case 'int':
        if (value is int) {
          _settingsVals[setting.index] = value;
          await _prefs.setInt(setting.toShortString(), value);
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

  static const _settingsTypes = <String>[
    'bool', // notifications
    'bool', // lecturesNotifications
    'bool', // eventsNotifications
    'int', // minutesBeforeLecNotifications
    'int', // minutesBeforeEventNotifications
  ];
} // SettingsServices

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
