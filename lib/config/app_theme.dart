import 'package:flutter/material.dart';

const Color kBackgroundColor = Color.fromRGBO(253, 254, 253, 1);
const Color kPrimaryColor = Color.fromRGBO(22, 71, 68, 1);
const Color kAccentColor = Color.fromRGBO(27, 181, 177, 1);
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
