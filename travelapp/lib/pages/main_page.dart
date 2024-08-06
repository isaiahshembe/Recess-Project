import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/car_rentals.dart';
import 'package:touristapp/pages/more/Events.dart';
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
    _carouselTimer?.cancel();
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
        filteredItems = allItems;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<TourismPlace>> _findNearbyPlaces(
      double latitude, double longitude) async {
    try {
      const double latitudeRange = 0.2;
      const double longitudeRange = 0.2;

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
        title: const Text('TravelApp'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Banner Section
            Container(
              color: Colors.green,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildBannerButton(
                            'Hotels',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaysPage()))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildBannerButton(
                            'Things to Do',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PreferencesScreen()))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBannerButton(
                            'Restaurants',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantsPage()))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildBannerButton(
                            'More',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CarRentalContentPage()))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildCarouselItem(
                            'images/murchison falls np.jpg',
                            'Discover Hidden Gems'),
                        _buildCarouselItem(
                            'images/camping 2.jpg', 'Adventure Awaits'),
                        _buildCarouselItem(
                            'images/westnile.jpeg', 'Explore Nature'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Search Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: TextField(
            //     controller: _searchController,
            //     decoration: InputDecoration(
            //       labelText: 'Search',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       suffixIcon: IconButton(
            //         icon: const Icon(Icons.search),
            //         onPressed: () {
            //           _filterResults(_searchController.text);
            //         },
            //       ),
            //     ),
            //     onChanged: (value) {
            //       _filterResults(value);
            //     },
            //   ),
            // ),
            const SizedBox(height: 10),
            // Items List Section
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildPlaceItem(filteredItems[index]);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildBannerButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.green, backgroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(title),
    );
  }

  Widget _buildCarouselItem(String imagePath, String text) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.3),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceItem(TourismPlace place) {
    return GestureDetector(
      onTap: () => _navigateToDetails(place),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: place.image.isNotEmpty
                    ? Image.network(
                        place.image,
                        fit: BoxFit.cover,
                        height: 70, // Adjust height as needed
                        width: double.infinity, // Ensure width adjusts
                      )
                    : Container(
                        color: Colors.grey,
                        height: 70,
                        width: double.infinity,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
