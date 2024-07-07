import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:touristapp/pages/editprofilepage.dart';
<<<<<<< HEAD
import 'settings.dart';
=======
import 'package:touristapp/pages/settings_page.dart';
>>>>>>> c3dc173418b25016124f4d761cdc991262b1c90c

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.to(EditProfilePage());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 16),
            Text(
              'Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Booking History'),
              onTap: () {
                // Navigate to Booking History Page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
<<<<<<< HEAD
                // Navigate to Settings Page
=======
>>>>>>> c3dc173418b25016124f4d761cdc991262b1c90c
                Get.to(SettingsPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              onTap: () {
                // Navigate to Help & Support Page
              },
            ),
          ],
        ),
      ),
    );
  }
}
