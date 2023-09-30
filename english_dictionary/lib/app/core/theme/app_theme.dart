import 'package:flutter/material.dart';
import 'color_schemes.dart';

final appTheme = ThemeData(
  colorScheme: lightColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: lightColorScheme.onPrimary,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color.fromARGB(255, 202, 23, 23),
    actionTextColor: lightColorScheme.onError,
    behavior: SnackBarBehavior.floating,
  ),
  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFC1C1C1).withOpacity(.25),
      hintStyle: const TextStyle(
        color: Color(0xFFA2A2A2),
        fontSize: 14,
      )),
);
