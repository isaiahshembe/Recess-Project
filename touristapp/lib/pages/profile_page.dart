import 'package:flutter/material.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text('Profile Page'),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}