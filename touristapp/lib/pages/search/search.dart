import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/search/result.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _preferenceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch places from Firestore based on preferences
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('places')
          .where('category', isEqualTo: _preferenceController.text)
          .get();

      List<Map<String, dynamic>> results = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Calculate distance
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          data['location'].latitude,
          data['location'].longitude,
        );

        data['distance'] = distance;
        results.add(data);
      }

      if (results.isEmpty) {
        // Fetch nearby places if no exact matches
        querySnapshot = await FirebaseFirestore.instance
            .collection('places')
            .limit(5) // Adjust this query to fit your Firestore capabilities
            .get();

        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            data['location'].latitude,
            data['location'].longitude,
          );

          data['distance'] = distance;
          results.add(data);
        }
      }

      // Navigate to results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(results: results),
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for Places'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _preferenceController,
              decoration: const InputDecoration(
                labelText: 'Enter your preferences',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _search,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
