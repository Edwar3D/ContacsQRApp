import 'package:flutter/material.dart';
import 'package:qr_app/pages/contacts_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.lightBlue.shade800),
          elevation: 0,
          color: Color.fromRGBO(36, 113, 163, 1),
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              height: 1.5),
          headline2: TextStyle(
            color: Color.fromRGBO(36, 113, 163, 1),
            fontSize: 25,
            height: 2,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            color: Color.fromRGBO(244, 246, 246, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          headline4: TextStyle(
            color: Color.fromRGBO(28, 40, 51, 1),
            fontSize: 18,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
          ),
          bodyText1: TextStyle(
            color: Colors.blue.shade900,
          ),
        ),
      ),
      home: ContactsList(),
    );
  }
}
