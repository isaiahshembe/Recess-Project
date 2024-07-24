import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:touristapp/pages/Welcomepage/welcomepage.dart'; // Import the correct page
import 'package:touristapp/pages/login_screen.dart'; // Import the correct page
// import 'package:touristapp/pages/TrendingFeaturesPage/trending_features_page.dart'; // Import the correct page if needed
=======
import 'package:touristapp/pages/Welcomepage/welcomepage.dart';
import 'package:touristapp/pages/login_screen.dart';
import 'package:touristapp/pages/main_page.dart';
>>>>>>> 839053b8eebb80d2fdb44a29397ecd105daf140d

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
<<<<<<< HEAD
          builder: (context) => user != null ? const WelcomePage() : const LoginScreen(),
=======
          builder: (context) => user != null ? WelcomePage() : MainPage(),
>>>>>>> 839053b8eebb80d2fdb44a29397ecd105daf140d
        ),
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
