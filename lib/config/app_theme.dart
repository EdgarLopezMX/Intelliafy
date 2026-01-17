import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xFFF2F4F7);
const Color kPrimaryColor = Color(0xFF2C3E50);
const Color kAccentColor = Color(0xFF00BFA5);
const Color kErrorColor = Color(0xFFFF0000);
const Color kTextColor = Color(0xFF444444);

ThemeData buildIntelliafyTheme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kAccentColor,
      surface: kBackgroundColor,
    ),

    //-----------//

    focusColor: kAccentColor,

    //-----------//

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24.0, color: kPrimaryColor),
      bodyLarge: TextStyle(fontSize: 16.0, color: kPrimaryColor),
      //all remaing styles
    ).apply(
      fontFamily: 'Inter',
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

    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: kPrimaryColor,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kAccentColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kAccentColor,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kErrorColor,
        ),
      ),
    ),
  );
}
