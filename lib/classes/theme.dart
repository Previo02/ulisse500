import 'package:flutter/material.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      selectedIconTheme: IconThemeData(
        size: 25,
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: "Trajan",
      ),
      unselectedIconTheme: IconThemeData(
        size: 20,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "Trajan",
      ),
      backgroundColor: Color.fromRGBO(178, 146, 247, 1),
    ),
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
      backgroundColor: Color.fromRGBO(178, 146, 247, 1),
    ),
  );
}
