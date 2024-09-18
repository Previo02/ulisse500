import 'package:flutter/material.dart';

ThemeData themeData(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final appBarHeight = screenHeight * 0.10;

  return ThemeData(
    /*
     * Bottom Bar
     */
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
      backgroundColor: Colors.black54,
    ),
    /*
     * App Bar
     */
    appBarTheme: AppBarTheme(
      toolbarHeight: appBarHeight,
      centerTitle: true,
      elevation: 0.2,
      titleTextStyle: const TextStyle(
        fontFamily: "Trajan",
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 22,
      ),
      backgroundColor: Colors.black54,
    ),
  );
}
