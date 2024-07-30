// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:touristapp/pages/signup_screen.dart';
// import 'package:touristapp/pages/main_page.dart'; // Import your MainPage here

// class PreferencesScreen extends StatefulWidget {
//   @override
//   _PreferencesScreenState createState() => _PreferencesScreenState();
// }

// class _PreferencesScreenState extends State<PreferencesScreen> {
//   List<Category> categories = [
//     Category('Historical Sites', false),
//     Category('Natural Wonders', false),
//     Category('Entertainment', false),
//     Category('Cultural Experiences', false),
//     Category('Adventure Activities', false),
//     Category('Family-Friendly', false),
//     Category('Art and Exhibitions', false),
//     Category('Dining and Shopping', false),
//     Category('Relaxation and Wellness', false),
//     Category('Nightlife', false),
//     Category('Sports and Recreation', false),
//     Category('Landmarks', false),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Preferred Attractions'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: categories.map((category) {
//             return CheckboxListTile(
//               title: Text(category.name),
//               value: category.isSelected,
//               onChanged: (bool? value) {
//                 setState(() {
//                   category.isSelected = value!;
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the main page
//           savePreferences();
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MainPage()), // Navigate to the main page
//           );
//         },
//         child: Icon(Icons.arrow_forward), // Use a "go" icon
//       ),
//     );
//   }

//   void savePreferences() {
//     List<String> selectedCategories = categories
//         .where((category) => category.isSelected)
//         .map((category) => category.name)
//         .toList();

//     // Here you can save selectedCategories to your database or use it to filter attractions
//     print('Selected Categories: $selectedCategories');
//   }
// }

// class Category {
//   final String name;
//   bool isSelected;

//   Category(this.name, this.isSelected);
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/resultpref.dart'; 

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tailor Your Experiences'),
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
        onPressed: _isLoading ? null : () async {
          setState(() {
            _isLoading = true;
          });

          // Fetch data based on preferences and navigate to the results page
          List<Map<String, dynamic>> results = await fetchPreferences();
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultsScreen(results: results)),
          );
        },
        child: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchPreferences() async {
    List<String> selectedCategories = categories
        .where((category) => category.isSelected)
        .map((category) => category.name)
        .toList();

    List<Map<String, dynamic>> results = [];

    try {
      for (String category in selectedCategories) {
        // Fetch sub-collection documents for each selected category
        QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
            .collection('preferences')
            .doc(category)
            .collection('places') 
            .get();

        for (var doc in categorySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          results.add(data);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return results;
  }
}

class Category {
  final String name;
  bool isSelected;

  Category(this.name, this.isSelected);
}
