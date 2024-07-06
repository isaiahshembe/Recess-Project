import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/booking_page.dart';
import 'package:touristapp/pages/main_page.dart';
import 'package:touristapp/pages/profile_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.to(BookingPage());
            },
            icon: Icon(Icons.place),
          ),
          IconButton(
              onPressed: () {
                Get.to(MainPage());
              },
              icon: Icon(Icons.home)),
          IconButton(
              onPressed: () {
                Get.to(ProfilePage());
              },
              icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
