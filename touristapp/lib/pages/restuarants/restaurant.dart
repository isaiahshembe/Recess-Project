import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> restaurants = [];

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    QuerySnapshot querySnapshot = await _firestore.collection('restaurants').get();
    setState(() {
      restaurants = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Restaurants',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = restaurants[index].data() as Map<String, dynamic>;
                return ListTile(
                  leading: Image.network(restaurant['image']),
                  title: Text(restaurant['name']),
                  subtitle: Text(restaurant['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailsPage(restaurant: restaurant),
                      ),
                    );
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

class RestaurantDetailsPage extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  RestaurantDetailsPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(restaurant['image']),
            SizedBox(height: 16),
            Text(
              restaurant['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              restaurant['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Address: ${restaurant['address']}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more details and actions like booking a table or viewing on map
          ],
        ),
      ),
    );
  }
}
