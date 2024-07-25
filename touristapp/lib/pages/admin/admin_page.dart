import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
                child: Text(
              'Welcome Admin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            )),
            SizedBox(
              height: 70,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 70),
                    backgroundColor: Color.fromARGB(255, 114, 197, 118)),
                onPressed: () {
                  Get.to(TourismPageEdit());
                },
                child: Text('Tourism site')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 70),
                    backgroundColor: Color.fromARGB(255, 114, 197, 118)),
                onPressed: () {},
                child: Text('Hotel'))
          ],
        ),
      ),
    );
  }
}
