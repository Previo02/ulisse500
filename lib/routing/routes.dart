import 'package:flutter/material.dart';
import 'package:ulisse500/screens/login.dart';
import 'package:ulisse500/routing/navigator.dart';

class AppRoutes {
  static const String login = '/login';
  static const String navigator = '/navigator';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      navigator: (context) => const NavigatorPage(),
    };
  }
}