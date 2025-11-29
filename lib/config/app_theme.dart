import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xFFF2F4F7);
const Color kPrimaryColor = Color(0xFF2C3E50);
const Color kAccentColor = Color(0xFF00BFA5);

ThemeData buildIntelliafyTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBackgroundColor,
    primaryColor: kPrimaryColor,

    //-----------//

    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kAccentColor,
      surface: kBackgroundColor,
    ),

    //-----------//

    fontFamily: 'Inter',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24.0, color: kPrimaryColor),
      bodyLarge: TextStyle(fontSize: 16.0, color: kPrimaryColor),
      //all remaing styles
    ),

    //-----------//

    cardTheme: CardThemeData(
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    //-----------//

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
    ),
  );
}
