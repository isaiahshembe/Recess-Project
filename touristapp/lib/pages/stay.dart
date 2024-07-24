import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key});

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
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
                  label: const Text('Price'), 
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
                FilterChip(
                  label: const Text('Rating'),
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
                FilterChip(
                  label: const Text('Location'),
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
                final stay = filteredStays[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: stay['image'] != null
                            ? Image.network(
                                stay['image'], // Assuming 'image' field in Firestore
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(stay['name'] ?? 'No name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stay['description'] ?? 'No description'),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow, size: 16),
                                Text(filteredStays[index]['rating'].toString()), 
                              ],
                            ),
                            Text('\$${stay['price']?.toString() ?? 'No price'} per night'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
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
              icon: const Icon(Icons.map),
              label: const Text('View on Map'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
