import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/admin/admin_page.dart';
import 'package:touristapp/pages/login_screen.dart';
import 'package:touristapp/pages/profile/editprofilepage.dart';
import 'package:touristapp/pages/settings/helpsupport.dart';
import 'package:touristapp/pages/settings/settings_page.dart';
import 'package:touristapp/pages/userbooking.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final bool isAdmin = user != null &&
        (user.email == 'ofwonojohn004@gmail.com' || user.email == 'nuweisaiah@gmail.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[800], // Match the theme color
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(const ProfileEditScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: user != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage('images/profile.jpg') as ImageProvider,
                    child: user.photoURL == null || user.photoURL!.isEmpty
                        ? const Icon(Icons.camera_alt, size: 50, color: Colors.white70)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'No name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? 'No email',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.history, color: Colors.green),
                          title: const Text('Booking History'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const UserBookingsPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings, color: Colors.green),
                          title: const Text('Settings'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SettingsPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.help, color: Colors.green),
                          title: const Text('Help & Support'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: Text('Loading...')),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Get.to(const AdminPage());
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.green[800], // Match with AppBar color
            )
          : null,
    );
  }
}
