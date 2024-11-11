import 'package:flutter/material.dart';

double defaultGap = 20;
double gap(BuildContext context, double procent) {
  return MediaQuery.of(context).size.height / 100 * procent;
}

const apiKey = "<add-your-OpenAI-key";

const colorElement = Color(0xff10A37F);

class MyThemes {
  static final darkThemes = ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
          filled: true, fillColor: Color(0xFF484954)),
      cardTheme: CardTheme(
        color: const Color(0xFF444550),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFF343541),
          contentTextStyle: TextStyle(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white)),
      textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.white)),
      popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF343541)),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF343541)),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all<Color>(Colors.white))),
      radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith((states) => Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      primaryColor: Colors.white,
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: const Color(0xFF343541),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0x0ffd5d67),
          tertiary: const Color(0xFF5d5d67)));

  static final lightTheme = ThemeData(
      inputDecorationTheme:
          InputDecorationTheme(filled: true, fillColor: Colors.grey[350]),
      textTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black)),
      cardTheme: CardTheme(
        color: Colors.grey[350],
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black)),
      popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, foregroundColor: Colors.black),
      iconTheme: const IconThemeData(color: Colors.black),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all<Color>(Colors.black))),
      radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith((states) => Colors.black)),
      primaryColor: Colors.black,
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Colors.grey[350], tertiary: Colors.grey[350]));
}
