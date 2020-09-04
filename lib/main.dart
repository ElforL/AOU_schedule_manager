import 'package:flutter/material.dart';

import 'screens/HomePage.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  var coursesList;

  @override
  Widget build(BuildContext context) {
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
      home: MyHomePage(coursesList: coursesList),
    );
  }
}


