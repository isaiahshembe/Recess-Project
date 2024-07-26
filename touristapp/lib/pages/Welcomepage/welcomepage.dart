import 'package:flutter/material.dart';
import 'package:touristapp/pages/car_rentals.dart';
import 'package:touristapp/pages/preference.dart'; // Updated import for PreferencesScreen
import 'package:touristapp/pages/stay.dart';
import 'package:touristapp/add.dart'; // Import for AddCategoriesPage

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  // Example image URLs and captions
  final List<Map<String, dynamic>> bannerImages = [
    {'image': 'images/kidepo.jpeg', 'caption': 'Explore beautiful destinations'},
    {'image': 'images/kampala-sheraton-hotel.jpg', 'caption': 'Find cozy stays'},
    {'image': 'images/westnile.jpeg', 'caption': 'Discover exciting attractions'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased height for the app bar
        child: Container(
          color: Colors.blue, // Background color for the app bar
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.hotel, 'Stays', 0),
                _buildNavItem(Icons.attractions, 'Attractions', 1),
                _buildNavItem(Icons.directions_car, 'Car Rentals', 2),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const <Widget>[
                StaysPage(),
                PreferencesScreen(), // Replaced MainPage with PreferencesScreen
                CarRentalContentPage(),
              ],
            ),
          ),
          // Button to add categories
          
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _onNavItemTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.transparent,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.blue : Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
