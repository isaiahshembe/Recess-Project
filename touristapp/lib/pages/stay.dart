import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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
      List<Map<String, dynamic>> fetchedStays = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final latitude = _getDoubleFromField(data['location']['latitude']);
        final longitude = _getDoubleFromField(data['location']['longitude']);
        return {
          'id': doc.id,
          ...data,
          'location': {
            'latitude': latitude,
            'longitude': longitude,
          },
        };
      }).toList();

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

  double _getDoubleFromField(dynamic field) {
    if (field is String) {
      return double.tryParse(field) ?? 0.0;
    } else if (field is num) {
      return field.toDouble();
    } else {
      return 0.0;
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in kilometers
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLon = (lon2 - lon1) * pi / 180;
    final double a = 
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
      sin(dLon / 2) * sin(dLon / 2); 
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a)); 
    final double distance = R * c; // Distance in kilometers
    return distance;
  }

  Future<List<Map<String, dynamic>>> _fetchNearbyStays(double lat, double lon) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Places').get();
      List<Map<String, dynamic>> allStays = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final stayLat = _getDoubleFromField(data['location']['latitude']);
        final stayLon = _getDoubleFromField(data['location']['longitude']);
        return {
          'id': doc.id,
          ...data,
          'location': {
            'latitude': stayLat,
            'longitude': stayLon,
          },
        };
      }).toList();

      // Filter stays based on distance
      List<Map<String, dynamic>> nearbyStays = allStays.where((stay) {
        double stayLat = stay['location']['latitude'];
        double stayLon = stay['location']['longitude'];
        double distance = _calculateDistance(lat, lon, stayLat, stayLon);
        return distance <= 10; // Example: filter stays within 10 km
      }).toList();

      return nearbyStays;
    } catch (e) {
      print('Error fetching nearby stays: $e');
      return [];
    }
  }

  void _showStayDetails(BuildContext context, Map<String, dynamic> stay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    stay['image'] != null
                        ? Image.network(stay['image'], fit: BoxFit.cover)
                        : Container(
                            height: 200,
                            color: Colors.grey,
                            child: const Icon(Icons.image_not_supported, size: 100),
                          ),
                    const SizedBox(height: 16),
                    Text(stay['name'] ?? 'No name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(stay['description'] ?? 'No description'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(
                          (stay['averageRating'] != null
                                  ? double.tryParse(stay['averageRating'].toString()) ?? 0.0
                                  : 0.0)
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('\$${stay['price']?.toString() ?? 'No price'} per night'),
                    const SizedBox(height: 16),
                    const Text('Nearby Stays:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchNearbyStays(stay['location']['latitude'], stay['location']['longitude']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No nearby stays found');
                        } else {
                          return Column(
                            children: snapshot.data!.map((nearbyStay) {
                              return ListTile(
                                leading: nearbyStay['image'] != null
                                    ? Image.network(
                                        nearbyStay['image'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.broken_image, size: 50);
                                        },
                                      )
                                    : const Icon(Icons.image_not_supported, size: 50),
                                title: Text(nearbyStay['name'] ?? 'No name'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(nearbyStay['description'] ?? 'No description'),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                                        Text(
                                          (nearbyStay['averageRating'] != null
                                                  ? double.tryParse(nearbyStay['averageRating'].toString()) ?? 0.0
                                                  : 0.0)
                                              .toStringAsFixed(1),
                                        ),
                                      ],
                                    ),
                                    Text('\$${nearbyStay['price']?.toString() ?? 'No price'} per night'),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _filterStays(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStays = stays;
      } else {
        filteredStays = stays.where((stay) {
          final name = stay['name']?.toLowerCase() ?? '';
          final description = stay['description']?.toLowerCase() ?? '';
          final lowerQuery = query.toLowerCase();
          return name.contains(lowerQuery) || description.contains(lowerQuery);
        }).toList();
      }
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
              ),
              onChanged: _filterStays,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStays.length,
              itemBuilder: (context, index) {
                final stay = filteredStays[index];
                return ListTile(
                  leading: stay['image'] != null
                      ? Image.network(
                          stay['image'],
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
                          Text(
                            (stay['averageRating'] != null
                                    ? double.tryParse(stay['averageRating'].toString()) ?? 0.0
                                    : 0.0)
                                .toStringAsFixed(1),
                          ),
                        ],
                      ),
                      Text('\$${stay['price']?.toString() ?? 'No price'} per night'),
                    ],
                  ),
                  onTap: () => _showStayDetails(context, stay),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
