import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/preference.dart';
import 'package:touristapp/pages/restuarants/restaurant.dart';
import 'package:touristapp/pages/stay.dart';
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

  final PageController _pageController = PageController();
  Timer? _carouselTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchTourismPlaces();
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel(); // Cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchTourismPlaces() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tourism_places').get();
      List<TourismPlace> places = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TourismPlace(
          id: doc.id,
          name: data['name'] ?? 'Unknown Name',
          image: data['image'] ?? 'https://via.placeholder.com/150',
          location: data['location'] ?? 'Unknown Location',
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          description: data['description'] ?? '',
          latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();

      setState(() {
        allItems = places;
        filteredItems = allItems; // No filtering by category
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error
    }
  }

  Future<List<TourismPlace>> _findNearbyPlaces(
      double latitude, double longitude) async {
    try {
      const double latitudeRange = 0.2; // Adjust based on your needs
      const double longitudeRange = 0.2; // Adjust based on your needs

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tourism_places')
          .where('latitude', isGreaterThan: latitude - latitudeRange)
          .where('latitude', isLessThan: latitude + latitudeRange)
          .where('longitude', isGreaterThan: longitude - longitudeRange)
          .where('longitude', isLessThan: longitude + longitudeRange)
          .get();

      List<TourismPlace> places = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TourismPlace(
          id: doc.id,
          name: data['name'] ?? 'Unknown Name',
          image: data['image'] ?? 'https://via.placeholder.com/150',
          location: data['location'] ?? 'Unknown Location',
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          description: data['description'] ?? '',
          latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();

      return places;
    } catch (e) {
      print('Error finding nearby places: $e');
      return [];
    }
  }

  void _filterResults(String query) {
    List<TourismPlace> results = query.isEmpty
        ? allItems
        : allItems
            .where((place) =>
                place.name.toLowerCase().contains(query.toLowerCase()) ||
                place.location.toLowerCase().contains(query.toLowerCase()))
            .toList();

    setState(() {
      filteredItems = _rankResults(results);
    });
  }

  List<TourismPlace> _rankResults(List<TourismPlace> results) {
    results.sort((a, b) => b.rating.compareTo(a.rating));
    return results;
  }

  void _navigateToDetails(TourismPlace place) async {
    List<TourismPlace> nearbyPlaces =
        await _findNearbyPlaces(place.latitude, place.longitude);

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
      DocumentReference placeRef =
          FirebaseFirestore.instance.collection('tourism_places').doc(placeId);
      DocumentSnapshot placeDoc = await placeRef.get();

      if (placeDoc.exists) {
        final data = placeDoc.data() as Map<String, dynamic>;

        List<dynamic> currentRatings =
            List<dynamic>.from(data['ratings'] ?? []);
        currentRatings.add(rating);

        double averageRating = currentRatings.isNotEmpty
            ? currentRatings.cast<double>().reduce((a, b) => a + b) /
                currentRatings.length
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

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) %
            3; // Change 3 to the number of items in your carousel
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourism Places'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          // Top Banner Section
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: _buildBannerButton(
                            'Hotels',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaysPage())))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildBannerButton(
                            'Things to Do',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PreferencesScreen())))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: _buildBannerButton('Restaurants', () {
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RestaurantsPage()));
                      // Implement navigation for Restaurants if needed
                    })),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildBannerButton('More', () {
                      // Implement navigation for More if needed
                    })),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildCarouselItem('images/murchison falls np.jpg',
                          'Discover Hidden Gems'),
                      _buildCarouselItem(
                          'images/camping 2.jpg', 'Adventure Awaits'),
                      _buildCarouselItem(
                          'images/murchision.jpg', 'Relax and Enjoy'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Banners Section
          Container(
            height: 300, // Adjust height as needed
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              children: [
                _buildBanner('images/westnile.jpeg', 'Experience the Best'),
                _buildBanner('images/kampala-sheraton-hotel.jpg',
                    'Top Rated Destinations'),
                _buildBanner('images/kidepo.jpeg', 'Hidden Treasures'),
                _buildBanner('images/muchison.jpg', 'Must-See Places'),
                const SizedBox(height: 10),
                // Explore Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final place = filteredItems[index];
                            return GestureDetector(
                              onTap: () => _navigateToDetails(place),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.only(right: 10),
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                        child: Image.network(
                                          place.image,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            place.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.green,
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
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildBannerButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath, String caption) {
    return Stack(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              caption,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(String imagePath, String caption) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
