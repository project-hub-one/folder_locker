import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folder_locker/screens/folder_list_screen.dart';
import 'package:folder_locker/screens/home_screen.dart';
import 'package:folder_locker/screens/lock_screen.dart';
import 'package:folder_locker/screens/unlock_screen.dart';
import 'package:folder_locker/screens/login_screen.dart';
import 'package:folder_locker/screens/signup_screen.dart';

void main() {
  runApp(FolderLockApp());
}

class FolderLockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Folder Lock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), // Start with splash screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/folders': (context) => FolderListScreen(),
        '/lock': (context) => LockScreen(),
        '/unlock': (context) => UnlockScreen(),
      },
    );
  }
}

// 🔹 Splash Screen - Checks Login State
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Navigate based on token existence
    Future.delayed(Duration(seconds: 2), () {
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}
