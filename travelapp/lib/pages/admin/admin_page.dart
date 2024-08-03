import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/admin/editing.dart';
import 'package:touristapp/pages/admin/hotel_add.dart';
import 'package:touristapp/pages/admin/tourism_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
                child: Text(
              'Welcome Admin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            )),
            const SizedBox(
              height: 70,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 70),
                    backgroundColor: const Color.fromARGB(255, 114, 197, 118)),
                onPressed: () {
                  Get.to(const TourismPageEdit());
                },
                child: const Text('Add a tourism site')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 70),
                    backgroundColor: const Color.fromARGB(255, 114, 197, 118)),
                onPressed: () {Get.to(const HotelAdd());},
                child: const Text('Add a hotel')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 70),
                    backgroundColor: const Color.fromARGB(255, 114, 197, 118)),
                onPressed: () {
                  Get.to(const EditingPage());
                },
                child: const Text('Editing'))
          ],
        ),
      ),
    );
  }
}
