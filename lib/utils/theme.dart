import 'package:flutter/material.dart';

const grey = Colors.grey;
const white = Colors.white;
const black = Colors.black;
const blue = Color(0xff1565C0);
const blueGray = Color(0xff738FA7);
const darkblue = Color(0xff071330);
const midnightBlue = Color(0xff0C4160);
const appcolor = Color.fromARGB(255, 7, 53, 68); // Main App Color
const lightAppcolor = Color.fromARGB(255, 32, 103, 124); // Light App Color
const midnightAppcolor = Color.fromARGB(255, 21, 72, 88); // MidLight App Color

// Light Mode Theme

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: appcolor,
  brightness: Brightness.light,
  cardColor: white,
  cardTheme: const CardTheme(elevation: 2),
  iconTheme: const IconThemeData(color: appcolor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: appcolor,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: black),
    backgroundColor: white,
    elevation: 0,
    actionsIconTheme: IconThemeData(color: black),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: black,
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
        bodyColor: black,
        displayColor: black,
        decorationColor: black,
      ),
  primaryTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
      ),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),
);

// Dark Mode Theme
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  primaryColor: appcolor,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: black,
  cardTheme: const CardTheme(elevation: 2),
  cardColor: midnightBlue.withOpacity(0.4),
  iconTheme: const IconThemeData(color: lightAppcolor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: appcolor,
    ),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: white),
    elevation: 0,
    backgroundColor: black,
    actionsIconTheme: IconThemeData(color: white),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: white,
    ),
  ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
        bodyColor: white,
        displayColor: white,
        decorationColor: white,
      ),
  primaryTextTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Baskerville',
      ),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),
);

Gradient gradient = const LinearGradient(
  colors: [
    Colors.black87,
    Color(0xff0F2027),
    Colors.black,
    Colors.black87,
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomRight,
);

Gradient gradient2 = const LinearGradient(
  colors: [Colors.black87, Color(0xff0F2027), Colors.black, Colors.black87],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);
