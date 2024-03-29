import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uni_assistant/services/UserServices.dart';

import 'constants.dart';
import 'screens/HomePage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/uni_launcher');
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static UserServices userServices;

  MyApp() {
    userServices = UserServices(new List());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AOU Schedule Manager',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,

        accentColor: Color(0xFFe7e7e7),

        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        ),

        brightness: Brightness.dark,
        // Setting background and appbar color
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: kBackgroundColor,
        ),

        iconTheme: IconThemeData(
          color: kOnBackgroundColor,
        ),
      ),
      home: MyHomePage(),
    );
  }
}
