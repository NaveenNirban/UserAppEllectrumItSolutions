import 'package:flutter/material.dart';
import 'package:user_app/config/route/router.dart' as router;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: router.Router.login,
      onGenerateRoute: router.Router.generateRoute,
    );
  }
}
