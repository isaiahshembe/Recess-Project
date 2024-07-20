import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaysPage extends StatefulWidget {
  @override
  _StaysPageState createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  List<Map<String, dynamic>> stays = [];
  List<Map<String, dynamic>> filteredStays = [];

  @override
  void initState() {
    super.initState();
    _fetchStays();
  }

  Future<void> _fetchStays() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Places').get();
      List<Map<String, dynamic>> fetchedStays = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        stays = fetchedStays;
        filteredStays = fetchedStays;
      });
    } catch (e) {
      print('Error fetching stays: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching stays: $e')),
      );
    }
  }

  void _filterStays(String query) {
    final filtered = stays
        .where((stay) => stay['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredStays = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stays'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search stays',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterStays(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChip(
                  label: Text('Price'), 
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
                FilterChip(
                  label: Text('Rating'),
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
                FilterChip(
                  label: Text('Location'),
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStays.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          filteredStays[index]['image_path'], // Use 'image_path' field from Firestore
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(filteredStays[index]['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filteredStays[index]['description']),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 16),
                                Text(filteredStays[index]['rating'].toString()), 
                              ],
                            ),
                            Text('\$${filteredStays[index]['price']} per night'),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Implement navigation to stay details
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Implement navigation to map view
              },
              icon: Icon(Icons.map),
              label: Text('View on Map'),
            ),
          ),
        ],
      ),
    );
  }
}
