import 'package:flutter/material.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text('Bookings Page'),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}