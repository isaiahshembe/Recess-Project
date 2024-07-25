import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
    final bool isAdmin = user != null &&
        (user.email == 'ofwonojohn004@gmail.com' || user.email == 'nuweisaiah@gmail.com');

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
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('User data not found'));
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>?;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData?['photoURL'] != null && userData!['photoURL'].isNotEmpty
                            ? NetworkImage(userData['photoURL'])
                            : AssetImage('images/profile.jpg') as ImageProvider,
                        child: userData?['photoURL'] == null || userData!['photoURL'].isEmpty
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.white70)
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text(
                        user.email ?? 'No email',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userData?['displayName'] ?? 'No name', // Display updated name
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
                );
              },
            )
          : Center(child: Text('Loading...')),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Get.to(AdminPage());
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
