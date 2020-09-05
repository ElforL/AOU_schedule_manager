import 'package:flutter/material.dart';
import 'package:uni_assistant/models/Course.dart';
import 'package:uni_assistant/models/Event.dart';
import 'package:uni_assistant/models/Lecture.dart';
import 'package:uni_assistant/models/UserServices.dart';
import 'package:uni_assistant/models/myTimeOfDay.dart';

import 'constants.dart';
import 'screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static UserServices userServices;
  
  @override
  Widget build(BuildContext context){

    userServices = UserServices(new List());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Setting background and appbar color
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),

        iconTheme: IconThemeData(
          color: kOnBackgroundColor,
        ),

      ),
      home: MyHomePage(userServices: userServices),
    );
  }
}


