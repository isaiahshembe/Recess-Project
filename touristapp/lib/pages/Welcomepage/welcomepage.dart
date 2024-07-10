import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/car_rentals.dart';
import 'package:touristapp/pages/main_page.dart';
import 'package:touristapp/pages/profile_page.dart';
import 'package:touristapp/pages/settings.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
              KeySectorsSection(),
              SizedBox(height: 16),
              Text(
                'Find exclusive genius rewards in every corner of the world',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TrendingDestinationsSection(),
              SizedBox(height: 16),
              OtherCitiesSection(),
              SizedBox(height: 16),
              Text(
                'Explore Uganda.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              MoreCitiesSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class KeySectorsSection extends StatelessWidget {
  final List<Map<String, dynamic>> keySectors = [
    {'name': 'Stays', 'icon': Icons.hotel, 'page': ProfilePage()},
    {'name': 'Attractions', 'icon': Icons.attractions, 'page': MainPage()},
    {'name': 'Car Rentals', 'icon': Icons.directions_car, 'page': CarRentalsPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keySectors.map((sector) {
        return GestureDetector(
          onTap: () {
            Get.to(sector['page']);
          },
          child: Column(
            children: [
              Icon(sector['icon'], size: 50),
              Text(sector['name']),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class TrendingDestinationsSection extends StatelessWidget {
  final List<Map<String, String>> trendingDestinations = [
    {'name': 'Kampala', 'image': 'images/muchison.jpg'},
    {'name': 'Entebbe', 'image': 'images/muchison.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class OtherCitiesSection extends StatelessWidget {
  final List<Map<String, String>> otherCities = [
    {'name': 'Toronto', 'image': 'images/muchison.jpg'},
    {'name': 'Nairobi', 'image': 'images/muchison.jpg'},
    {'name': 'Dubai', 'image': 'images/muchison.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class MoreCitiesSection extends StatelessWidget {
  final List<Map<String, String>> moreCities = [
    {'name': 'Mbarara', 'image': 'images/muchison.jpg'},
    {'name': 'Entebbe', 'image': 'images/muchison.jpg'},
    {'name': 'Jinja', 'image': 'images/muchison.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
    );
  }
}
