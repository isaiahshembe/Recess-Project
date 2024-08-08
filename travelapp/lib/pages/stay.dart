import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key});

  @override
  _StaysPageState createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  List<Map<String, dynamic>> stays = [];
  List<Map<String, dynamic>> filteredStays = [];
  double userLatitude = 0.0;
  double userLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStays();
    _fetchUserLocation();
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

  Future<void> _fetchUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });

      print('User location: $userLatitude, $userLongitude');
    } catch (e) {
      print('Error fetching user location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user location: $e')),
      );
    }
  }

  Future<void> _fetchNearbyHotels() async {
    final apiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw';
    final radius = 5000; // Radius in meters
    final type = 'hotel';

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$userLatitude,$userLongitude'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        List<Map<String, dynamic>> nearbyHotels = results.map((hotel) {
          return {
            'id': hotel['place_id'],
            'hotel_name': hotel['name'],
            'description': hotel['vicinity'],
            'image': hotel['photos'] != null
                ? 'https://maps.googleapis.com/maps/api/place/photo'
                  '?maxwidth=400'
                  '&photoreference=${hotel['photos'][0]['photo_reference']}'
                  '&key=$apiKey'
                : null,
            'averageRating': hotel['rating'] ?? 0.0,
            'ratingCount': hotel['user_ratings_total'] ?? 0,
            'room_cost': 100.0, // Dummy value
          };
        }).toList();

        setState(() {
          filteredStays = nearbyHotels;
        });
      } else {
        print('Failed to load nearby hotels');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load nearby hotels')),
        );
      }
    } catch (e) {
      print('Error fetching nearby hotels: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching nearby hotels: $e')),
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
      backgroundColor: Colors.white,
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
                    Text(
                      stay['hotel_name'] ?? 'No name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stay['description'] ?? 'No description',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(
                          (stay['averageRating'] != null
                              ? stay['averageRating'].toStringAsFixed(1)
                              : '0.0'),
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${stay['ratingCount'] ?? 0} ratings)',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${stay['room_cost']?.toString() ?? 'No price'} per night',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rate this hotel:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.green,
                      ),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (rating > 0) {
                          _updateHotelRating(stay['id'], rating);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please provide a rating'),
                            ),
                          );
                        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stays'),
        backgroundColor: Colors.green,
      ),
      body: stays.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredStays.length,
              itemBuilder: (context, index) {
                final stay = filteredStays[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: stay['image'] != null
                        ? Image.network(stay['image'], width: 100, fit: BoxFit.cover)
                        : Container(
                            width: 100,
                            color: Colors.grey,
                            child: const Icon(Icons.image_not_supported, size: 40),
                          ),
                    title: Text(stay['hotel_name'] ?? 'No name'),
                    subtitle: Text(stay['description'] ?? 'No description'),
                    trailing: Text(
                      '\$${stay['room_cost']?.toString() ?? 'No price'}',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _showStayDetails(context, stay),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchNearbyHotels,
        child: const Icon(Icons.hotel),
        backgroundColor: Colors.green,
        tooltip: 'Find Hotels Near Me',
      ),
    );
  }
}
