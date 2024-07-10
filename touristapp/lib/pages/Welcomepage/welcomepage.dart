import 'package:flutter/material.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final List<Map<String, dynamic>> keySectors = [
    {'name': 'Stays', 'icon': Icons.hotel},
    {'name': 'Attractions', 'icon': Icons.attractions},
    {'name': 'Car Rentals', 'icon': Icons.directions_car},
  ];

  final List<Map<String, String>> trendingDestinations = [
    {'name': 'Kampala', 'image': 'images/muchison.jpg'},
    {'name': 'Entebbe', 'image': 'images/muchison.jpg'},
  ];

  final List<Map<String, String>> otherCities = [
    {'name': 'Toronto', 'image': 'images/muchison.jpg'},
    {'name': 'Nairobi', 'image': 'images/muchison.jpg'},
    {'name': 'Dubai', 'image': 'images/muchison.jpg'},
  ];

  final List<Map<String, String>> moreCities = [
    {'name': 'City1', 'image': 'images/muchison.jpg'},
    {'name': 'City2', 'image': 'images/muchison.jpg'},
    {'name': 'City3', 'image': 'images/muchison.jpg'},
    {'name': 'City4', 'image': 'images/muchison.jpg'},
    {'name': 'City5', 'image': 'images/muchison.jpg'},
    {'name': 'City6', 'image': 'images/muchison.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourist App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: keySectors.map((sector) {
                  return GestureDetector(
                    onTap: () {
                      // Handle sector tap
                    },
                    child: Column(
                      children: [
                        Icon(sector['icon'], size: 50),
                        Text(sector['name']),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Find exclusive genius rewards in every corner of the world',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: trendingDestinations.map((destination) {
                  return Stack(
                    children: [
                      Image.asset(destination['image']!, width: 150, height: 150, fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black54,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            destination['name']!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: otherCities.map((city) {
                  return Stack(
                    children: [
                      Image.asset(city['image']!, width: 100, height: 100, fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black54,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            city['name']!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Explore Uganda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: moreCities.map((city) {
                  return Stack(
                    children: [
                      Image.asset(city['image']!, width: 100, height: 100, fit: BoxFit.cover),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black54,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            city['name']!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
