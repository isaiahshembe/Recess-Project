import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/Welcomepage/welcomepage.dart';
import 'package:touristapp/pages/booking_page.dart';
import 'package:touristapp/pages/profile/profile_page.dart';
import 'package:touristapp/pages/stay.dart';

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
              Get.to(BookingPage(latitude: null!, longitude: null!,));
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

