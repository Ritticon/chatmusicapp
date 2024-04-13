import 'package:flutter/material.dart';

ThemeData lighmode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Color.fromARGB(255, 255, 185, 135), //Colors.grey.shade300 
    primary: Colors.grey.shade500, //4B2013
    secondary: Color(0xFFFE9F60),
    inversePrimary: Colors.grey.shade900,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFE9F60)
  ),
);