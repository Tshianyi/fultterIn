// ...existing code...
import '../view/home_page.dart';
import '../view/login_page.dart';
import '../view/signup_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const signup = '/signup';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => LoginPage(),
    signup: (context) => SignupPage(),
    home: (context) => HomePage(),
  };
}