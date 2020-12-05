import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uni_assistant/models/UserServices.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'AOU Schedule Manager',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,

        accentColor: Color(0xFFe7e7e7),

        textSelectionColor: Colors.blue,
        textSelectionHandleColor: Colors.blue,

        brightness: Brightness.dark,
        // Setting background and appbar color
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),

        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: kOnBackgroundColor,
        ),
      ),
      home: MyHomePage(),
    );
  }
}
