import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/tourism_detailPage.dart';
import 'package:touristapp/utilities/bottom_nav.dart';
import 'package:touristapp/tourism_place.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

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
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tourism_places').get();

      List<TourismPlace> places = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String name = data['name'] ?? 'Unknown Name';
        String image = data['image'] ?? 'https://via.placeholder.com/150';
        String location = data['location'] ?? 'Unknown Location';
        int rating = data['rating'] ?? 0;
        double price = data['price'] ?? 0.0;
        String description = data['description'] ?? '';

        TourismPlace place = TourismPlace(
          name: name,
          image: image,
          location: location,
          rating: rating,
          price: price,
          description: description,
        );
        places.add(place);
      });

      setState(() {
        allItems = places;
        filteredItems = allItems; // No filtering by category
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error
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
      filteredItems = _rankResults(results, query);
    });
  }

  List<TourismPlace> _rankResults(List<TourismPlace> results, String query) {
    results.sort((a, b) => b.rating.compareTo(a.rating));
    return results;
  }

  void _navigateToDetails(TourismPlace place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourismDetailsPage(place: place),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourism Places'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'images/display_image1.jpg', // Update path if necessary
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  place.image,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    place.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    place.location,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '\$${place.price.toStringAsFixed(2)}', // Format price
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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
