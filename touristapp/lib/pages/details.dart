import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const DetailScreen({required this.place, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? location = place['location'];

    return Scaffold(
      appBar: AppBar(title: Text(place['name'] ?? 'No name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            place['image'] != null
                ? Image.network(
                    place['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  )
                : Container(width: double.infinity, height: 200, color: Colors.grey), // Placeholder for missing images
            SizedBox(height: 16),
            Text(
              place['name'] ?? 'No name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(place['description'] ?? 'No description'),
            SizedBox(height: 16),
            if (location != null)
              Text(
                'Location: $location',
                style: TextStyle(color: Colors.grey[600]), // Optional styling
              )
            else
              Text('Location information is not available'),
          ],
        ),
      ),
    );
  }
}
