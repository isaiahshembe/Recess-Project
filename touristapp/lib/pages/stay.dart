import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hotels').get();
      List<Map<String, dynamic>> fetchedStays = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final latitude = _getDoubleFromField(data['location']?['latitude']);
        final longitude = _getDoubleFromField(data['location']?['longitude']);
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

  Future<void> _updateHotelRating(String hotelId, double rating) async {
    try {
      DocumentReference hotelRef = FirebaseFirestore.instance.collection('hotels').doc(hotelId);
      DocumentSnapshot hotelDoc = await hotelRef.get();

      if (hotelDoc.exists) {
        final data = hotelDoc.data() as Map<String, dynamic>;

        // Ensure the ratings field is always a list
        List<dynamic> currentRatings = data['ratings'] is List
            ? List<dynamic>.from(data['ratings'])
            : [];

        currentRatings.add(rating);

        double averageRating = currentRatings.isNotEmpty
            ? currentRatings.cast<double>().reduce((a, b) => a + b) / currentRatings.length
            : 0.0;
        int ratingCount = currentRatings.length;

        await hotelRef.update({
          'ratings': currentRatings,
          'averageRating': averageRating,
          'ratingCount': ratingCount,
        });

        print('Hotel rating updated successfully');
      } else {
        print('Hotel document does not exist');
      }
    } catch (e) {
      print('Error updating hotel rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating hotel rating: $e')),
      );
    }
  }

  void _showStayDetails(BuildContext context, Map<String, dynamic> stay) {
    double rating = 0.0;

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
                    Text(stay['hotel_name'] ?? 'No name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(stay['description'] ?? 'No description'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(
                          (stay['averageRating'] != null
                                  ? stay['averageRating'].toStringAsFixed(1)
                                  : '0.0'),
                        ),
                        const SizedBox(width: 8),
                        Text('(${stay['ratingCount'] ?? 0} ratings)'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('\$${stay['room_cost']?.toString() ?? 'No price'} per night'),
                    const SizedBox(height: 16),
                    const Text('Rate this hotel:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Update Firestore with the new rating
                        await _updateHotelRating(stay['id'], rating);

                        // Refresh the stay details to reflect the updated rating
                        Navigator.pop(context);
                        setState(() {
                          _fetchStays(); // Reload the stays list
                        });
                      },
                      child: const Text('Submit Rating'),
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
          final name = stay['hotel_name']?.toLowerCase() ?? '';
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
      appBar: AppBar(),
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
                  title: Text(stay['hotel_name'] ?? 'No name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stay['description'] ?? 'No description'),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 16),
                          Text(
                            (stay['averageRating'] != null
                                    ? stay['averageRating'].toStringAsFixed(1)
                                    : '0.0'),
                          ),
                        ],
                      ),
                      Text('\$${stay['room_cost']?.toString() ?? 'No price'} per night'),
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
