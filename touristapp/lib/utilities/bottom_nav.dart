import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/Welcomepage/welcomepage.dart';
import 'package:touristapp/pages/book/booking_page.dart';
import 'package:touristapp/pages/profile/profile_page.dart';
import 'package:touristapp/pages/stay.dart';
import 'package:touristapp/tourism_place.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.to(const StaysPage());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
<<<<<<< HEAD
              // Assuming the place is passed from the context or use a placeholder
              // Example placeholder
              TourismPlace placeholderPlace = TourismPlace(
                id: '1',
                name: 'Placeholder',
                image: 'https://via.placeholder.com/150',
                location: 'Placeholder Location',
                rating: 4.5,
                price: 100.0,
                description: 'Description',
                latitude: 37.7749,
                longitude: -122.4194,
              );

              Get.to(BookingPage());
=======
              Get.to(const BookingPage());
>>>>>>> b030437d5a3dbe09fa600ea9b19caa5033aeb35b
            },
            icon: const Icon(Icons.place),
          ),
          IconButton(
            onPressed: () {
              Get.to(const WelcomePage());
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {
              Get.to(const ProfilePage());
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

