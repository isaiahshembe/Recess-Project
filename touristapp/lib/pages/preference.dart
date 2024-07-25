import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:touristapp/pages/main_page.dart'; // Import your MainPage here

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<Category> categories = [
    Category('Historical Sites', false),
    Category('Natural Wonders', false),
    Category('Entertainment', false),
    Category('Cultural Experiences', false),
    Category('Adventure Activities', false),
    Category('Family-Friendly', false),
    Category('Art and Exhibitions', false),
    Category('Dining and Shopping', false),
    Category('Relaxation and Wellness', false),
    Category('Nightlife', false),
    Category('Sports and Recreation', false),
    Category('Landmarks', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Preferred Attractions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: categories.map((category) {
            return CheckboxListTile(
              title: Text(category.name),
              value: category.isSelected,
              onChanged: (bool? value) {
                setState(() {
                  category.isSelected = value!;
                });
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          savePreferences();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()), // Navigate to the main page
          );
        },
        child: Icon(Icons.arrow_forward), // Use a "go" icon
      ),
    );
  }

  void savePreferences() async {
    List<String> selectedCategories = categories
        .where((category) => category.isSelected)
        .map((category) => category.name)
        .toList();

    // Save selected preferences to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'preferences': selectedCategories,
      }, SetOptions(merge: true));

      print('Preferences saved: $selectedCategories');
    }
  }
}

class Category {
  final String name;
  bool isSelected;

  Category(this.name, this.isSelected);
}
