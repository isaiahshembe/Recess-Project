// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:touristapp/pages/login_screen.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text('Settings'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           ListTile(
//             leading: Icon(Icons.person),
//             title: const Text('Profile'),
//             onTap: () {
//               // Navigate to profile editing screen
//               // Example: Get.to(ProfilePage());
//               print('Navigate to profile editing screen');
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: const Text('Notifications'),
//             onTap: () {
//               // Navigate to notification settings screen
//               // Example: Get.to(NotificationSettingsPage());
//               print('Navigate to notification settings screen');
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.language),
//             title: const Text('Language'),
//             onTap: () {
//               // Navigate to language settings screen
//               // Example: Get.to(LanguageSettingsPage());
//               print('Navigate to language settings screen');
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () {
//               _logout(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _logout(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Get.offAll(LoginScreen()); // Redirect to LoginScreen and remove all previous routes
//     } catch (e) {
//       print('Error logging out: $e');
//       // Show error message or handle error as needed
//       // Example: showDialog(...);
//     }
//   }
// }
