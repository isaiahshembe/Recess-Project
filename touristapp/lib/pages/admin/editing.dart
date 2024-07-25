import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      padding:EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 70),
                      backgroundColor: Color.fromARGB(255, 114, 197, 118)),
                  onPressed: () {
                    Get.to(PlaceEditingPage());
                  },
                  child: Text('Tourism Places')),
                  SizedBox(height: 20,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 70),
                      backgroundColor: Color.fromARGB(255, 114, 197, 118)),
                  onPressed: () {},
                  child: Text('Hotels'))
            ],
          ),
        ),
      ),
    );
  }
}
