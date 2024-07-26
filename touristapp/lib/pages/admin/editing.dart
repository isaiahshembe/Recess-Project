import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touristapp/pages/admin/edit_hotel.dart';
import 'package:touristapp/pages/admin/place_editing_page.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({super.key});

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
      padding:const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: const Color.fromARGB(255, 114, 197, 118)),
                  onPressed: () {
                    Get.to(const PlaceEditingPage());
                  },
                  child: const Text('Tourism Places')),
                  const SizedBox(height: 20,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: const Color.fromARGB(255, 114, 197, 118)),
                  onPressed: () {
                    Get.to(HostelsPage());
                  },
                  child: const Text('Hotels'))
            ],
          ),
        ),
      ),
    );
  }
}
