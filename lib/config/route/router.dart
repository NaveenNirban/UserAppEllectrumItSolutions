import 'package:flutter/material.dart';
import 'package:user_app/pages/home.dart';
import 'package:user_app/pages/login.dart';
import 'package:user_app/pages/signup.dart';

class Router {
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        var username = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => Home(username: username.toString()));
      case login:
        return MaterialPageRoute(builder: (context) => const Login());
      case signup:
        return MaterialPageRoute(builder: (context) => const Signup());

      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }
}
