import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/DashboardScreen.dart';
import 'package:flutter_application_1/Screen/SignInScreen.dart';
import 'package:flutter_application_1/Screen/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/checkSession',
      routes: {
        '/checkSession': (context) => CheckSessionScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}

class CheckSessionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkUserSession(context);
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _checkUserSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
