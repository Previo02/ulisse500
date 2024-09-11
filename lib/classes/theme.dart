import 'package:flutter/material.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
    primaryColor: const Color.fromRGBO(151, 114, 232, 1),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0.2,
      titleTextStyle: TextStyle(
        fontFamily: "Trajan",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20,
      ),
      backgroundColor: Color.fromRGBO(151, 114, 232, 1),
    ),
  );
}
