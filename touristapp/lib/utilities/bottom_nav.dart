import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
=======

import 'package:touristapp/pages/google_map.dart';
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
import 'package:touristapp/pages/main_page.dart';
import 'package:touristapp/pages/profile_page.dart';
import 'package:touristapp/pages/booking_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.to(const BookingPage());
            },
            icon: const Icon(Icons.place),
          ),
          IconButton(
              onPressed: () {
                Get.to(const MainPage());
              },
              icon: const Icon(Icons.home)),
          IconButton(
              onPressed: () {
                Get.to(const ProfilePage());
              },
              icon: const Icon(Icons.person)),
        ],
      ),
    );
  }
}
