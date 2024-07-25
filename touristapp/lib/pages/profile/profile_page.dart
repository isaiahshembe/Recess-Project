import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:touristapp/pages/admin/admin_page.dart';
import 'package:touristapp/pages/login_screen.dart';
import 'package:touristapp/pages/profile/editprofilepage.dart';
import 'package:touristapp/pages/settings/helpsupport.dart';
import 'package:touristapp/pages/settings_page.dart';
import 'package:touristapp/pages/userbooking.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
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
              backgroundImage: AssetImage('assets/images/default_profile_image.jpg'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement FAB functionality here
          // Example: Navigate to edit profile page
          Get.to(AdminPage());
        },
        child: Icon(Icons.add), // Replace with appropriate icon
      ),
    );
  }
}
