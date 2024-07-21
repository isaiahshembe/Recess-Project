import 'dart:async';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:touristapp/pages/signup_screen.dart';
=======
import 'package:touristapp/pages/Welcomepage/features/features.dart';
>>>>>>> f0682adb89de1120f4fd51d419ac8e61738ae2eb

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/display_image1.jpg',
              height: 350.0,
              width: 250.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Welcome to TouristApp',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10.0),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
