import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:touristapp/pages/booking_page.dart';
import 'package:touristapp/pages/login_screen.dart';
import 'package:touristapp/pages/profile/editprofilepage.dart';
import 'package:touristapp/pages/settings/helpsupport.dart';
import 'package:touristapp/pages/settings_page.dart';
import 'package:touristapp/pages/userbooking.dart';
import '../settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  DocumentSnapshot? userDoc;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.to(ProfileEditScreen());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/profile.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              user != null ? user.email ?? 'No email' : 'Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'User Name', // Replace with actual user name if available
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Booking History'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserBookingsPage()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsPage()),
                  );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HelpSupportPage()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
