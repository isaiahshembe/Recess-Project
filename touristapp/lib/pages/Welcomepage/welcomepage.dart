import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart'; 
import 'package:touristapp/pages/car_rentals.dart';
import 'package:touristapp/pages/main_page.dart';
import 'package:touristapp/pages/stay.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Example image URLs and captions
  final List<Map<String, dynamic>> bannerImages = [
    {'image': 'images/kidepo.jpeg', 'caption': 'Explore beautiful destinations'},
    {'image': 'images/kampala-sheraton-hotel.jpg', 'caption': 'Find cozy stays'},
    {'image': 'images/westnile.jpeg', 'caption': 'Discover exciting attractions'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            CarouselSlider.builder(
              itemCount: bannerImages.length,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(bannerImages[index]['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      bannerImages[index]['caption'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            KeySectorsSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

class KeySectorsSection extends StatelessWidget {
  final List<Map<String, dynamic>> keySectors = [
    {'name': 'Stays', 'icon': Icons.hotel, 'page': StaysPage()},
    {'name': 'Attractions', 'icon': Icons.attractions, 'page': const MainPage()},
    {'name': 'Car Rentals', 'icon': Icons.directions_car, 'page': const CarRentalsPage()},
  ];

  KeySectorsSection({super.key});

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
