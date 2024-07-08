import 'package:flutter/material.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text('Google map page'),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}