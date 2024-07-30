import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/tourism_detailPage.dart';
import 'package:touristapp/utilities/bottom_nav.dart';
import 'package:touristapp/tourism_place.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, User? user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TourismPlace> allItems = [];
  List<TourismPlace> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchTourismPlaces();
  }

  Future<void> fetchTourismPlaces() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tourism_places').get();

      List<TourismPlace> places = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String name = data['name'] ?? 'Unknown Name';
        String image = data['image'] ?? 'https://via.placeholder.com/150';
        String location = data['location'] ?? 'Unknown Location';
        double rating = data['rating']?.toDouble() ?? 0.0;
        double price = data['price']?.toDouble() ?? 0.0;
        String description = data['description'] ?? '';
        double lat = data['latitude']?.toDouble() ?? 0.0;
        double lon = data['longitude']?.toDouble() ?? 0.0;

        TourismPlace place = TourismPlace(
          id: doc.id,
          name: name,
          image: image,
          location: location,
          rating: rating,
          price: price,
          description: description,
          latitude: lat,
          longitude: lon,
        );
        places.add(place);
      }

      setState(() {
        allItems = places;
        filteredItems = allItems; // No filtering by category
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error
    }
  }

  Future<List<TourismPlace>> _findNearbyPlaces(double latitude, double longitude) async {
    try {
      double latitudeRange = 0.2;  // Adjust this range based on your needs
      double longitudeRange = 0.2; // Adjust this range based on your needs

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tourism_places')
        .where('latitude', isGreaterThan: latitude - latitudeRange)
        .where('latitude', isLessThan: latitude + latitudeRange)
        .where('longitude', isGreaterThan: longitude - longitudeRange)
        .where('longitude', isLessThan: longitude + longitudeRange)
        .get();

      List<TourismPlace> places = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String name = data['name'] ?? 'Unknown Name';
        String image = data['image'] ?? 'https://via.placeholder.com/150';
        String location = data['location'] ?? 'Unknown Location';
        double rating = data['rating']?.toDouble() ?? 0.0;
        double price = data['price']?.toDouble() ?? 0.0;
        String description = data['description'] ?? '';
        double lat = data['latitude']?.toDouble() ?? 0.0;
        double lon = data['longitude']?.toDouble() ?? 0.0;

        TourismPlace nearbyPlace = TourismPlace(
          id: doc.id,
          name: name,
          image: image,
          location: location,
          rating: rating,
          price: price,
          description: description,
          latitude: lat,
          longitude: lon,
        );
        places.add(nearbyPlace);
      }

      return places;
    } catch (e) {
      print('Error finding nearby places: $e');
      return [];
    }
  }

  void _filterResults(String query) {
    List<TourismPlace> results = [];
    if (query.isEmpty) {
      results = allItems;
    } else {
      results = allItems.where((place) =>
        place.name.toLowerCase().contains(query.toLowerCase()) ||
        place.location.toLowerCase().contains(query.toLowerCase())).toList();
    }

    setState(() {
      filteredItems = _rankResults(results);
    });
  }

  List<TourismPlace> _rankResults(List<TourismPlace> results) {
    results.sort((a, b) => b.rating.compareTo(a.rating));
    return results;
  }

  void _navigateToDetails(TourismPlace place) async {
    // Example: Fetch nearby places based on the selected place's coordinates
    List<TourismPlace> nearbyPlaces = await _findNearbyPlaces(place.latitude, place.longitude);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourismDetailsPage(
          place: place,
          nearbyPlaces: nearbyPlaces,
          onRate: (double rating) => _ratePlace(place.id, rating),
        ),
      ),
    );
  }

  Future<void> _ratePlace(String placeId, double rating) async {
    try {
      DocumentReference placeRef = FirebaseFirestore.instance.collection('tourism_places').doc(placeId);
      DocumentSnapshot placeDoc = await placeRef.get();

      if (placeDoc.exists) {
        final data = placeDoc.data() as Map<String, dynamic>;

        List<dynamic> currentRatings = data['ratings'] is List
          ? List<dynamic>.from(data['ratings'])
          : [];

        currentRatings.add(rating);

        double averageRating = currentRatings.isNotEmpty
          ? currentRatings.cast<double>().reduce((a, b) => a + b) / currentRatings.length
          : 0.0;

        await placeRef.update({
          'ratings': currentRatings,
          'rating': averageRating,
          'ratingCount': currentRatings.length,
        });

        print('Place rating updated successfully');
      } else {
        print('Place document does not exist');
      }
    } catch (e) {
      print('Error updating place rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating place rating: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourism Places'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'images/display_image1.jpg', // Update path if necessary
                width: double.infinity,
                height: 150, // Adjust height as needed
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    hintText: 'What are you looking for?',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _filterResults(_searchController.text);
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {
                    _filterResults(text);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredItems.map((place) {
                          return GestureDetector(
                            onTap: () => _navigateToDetails(place),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(17),
                              ),
                              height: 200,
                              width: 200,
                              margin: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      place.image,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          place.location,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
