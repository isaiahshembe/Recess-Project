import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:touristapp/pages/Welcomepage/features/features.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 150,
                backgroundImage: AssetImage('images/display_image1.jpg'),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Login',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      filled: true,
                      hintText: 'Username',
                      prefixIcon: Icon(
                        Icons.person,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      hintText: 'password',
                      filled: true,
                      prefixIcon: Icon(
                        Icons.key,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: Text('Forgot password'))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor:
                          const Color.fromARGB(255, 100, 180, 103)),
                  onPressed: () {},
                  child: Text('Login'),
                )
              ],
            )),
            SizedBox(
                  height: 15,
                ),
            Center(
              child: GestureDetector(
                onTap: () {
                  print('hi');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/icons8-google-48.png',
                      height: 27,
                      width: 27,
                    ),SizedBox(width: 10,),
                    Text('Continue with google')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
