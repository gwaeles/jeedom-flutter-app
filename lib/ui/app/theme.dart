
import 'package:flutter/material.dart';

///
/// Responsibility :
/// - Theme definition
///
ThemeData appTheme(BuildContext context) => ThemeData(
// Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 131, 115, 46), // 83732e
//              accentColor: Color.fromARGB(255, 131, 82, 46),
//              cursorColor: Color.fromARGB(255, 131, 82, 46),
//              buttonColor: Color.fromARGB(255, 131, 82, 46),

//accentColor: Color.fromARGB(255, 169, 02, 57), // A90257
    accentColor: Color.fromARGB(255, 255, 230, 87), // A90257
    cursorColor: Color.fromARGB(255, 169, 02, 57),
    buttonColor: Color.fromARGB(255, 169, 02, 57),

//            backgroundColor: Colors.blueGrey,
    canvasColor: Color.fromARGB(255, 36, 54, 87), // 243657

// Define the default TextTheme. Use this to specify the default
// text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
//              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      display1: Theme.of(context).textTheme.display1.copyWith(
          color: Colors.white
      ),
      subhead: Theme.of(context).textTheme.subhead.copyWith(
          color: Colors.white54
      ),
    )
);