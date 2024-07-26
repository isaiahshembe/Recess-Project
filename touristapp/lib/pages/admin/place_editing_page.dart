import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/admin/edit.dart'; // Import your editing page

class PlaceEditingPage extends StatefulWidget {
  const PlaceEditingPage({super.key});

  @override
  State<PlaceEditingPage> createState() => _PlaceEditingPageState();
}

class _PlaceEditingPageState extends State<PlaceEditingPage> {
  List<String> tourismPlaces = [];
  List<String> filteredPlaces = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTourismPlaces(); // Fetch data when widget initializes
  }

  Future<void> fetchTourismPlaces() async {
    try {
      // Fetch all documents from "tourism_places" collection in Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tourism_places').get();

      setState(() {
        tourismPlaces = querySnapshot.docs.map((doc) => doc['name'] as String).toList(); // Store names
        filteredPlaces = tourismPlaces; // Initially, display all names
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching data: $e');
    }
  }

  void filterPlaces(String query) {
    setState(() {
      filteredPlaces = tourismPlaces
          .where((place) => place.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> editPlace(String placeName) async {
    try {
      // Fetch the specific document using the place name
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tourism_places')
          .where('name', isEqualTo: placeName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract document ID and data from the query result
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        // Navigate to editing page with document data and ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourismPageEdit(
              initialData: data,
              documentId: documentId,
            ),
          ),
        );
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      // Handle errors here
      print('Error fetching document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tourism Places'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterPlaces,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredPlaces[index]),
                  onTap: () {
                    // Handle item tap
                    editPlace(filteredPlaces[index]); // Pass place name to edit method
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
