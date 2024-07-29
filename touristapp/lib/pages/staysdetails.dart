import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const DetailScreen({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    final double? latitude = place['latitude'];
    final double? longitude = place['longitude'];

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
            const SizedBox(height: 16),
            Text(
              place['name'] ?? 'No name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(place['description'] ?? 'No description'),
            const SizedBox(height: 16),
            if (latitude != null && longitude != null)
              FutureBuilder<double>(
                future: _calculateDistance(latitude, longitude),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error calculating distance');
                  } else {
                    return Text('Distance: ${snapshot.data?.toStringAsFixed(2)} km');
                  }
                },
              )
            else
              const Text('Location information is not available'),
          ],
        ),
      ),
    );
  }

  Future<double> _calculateDistance(double lat, double lon) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      lat,
      lon,
    );
    return distanceInMeters / 1000; // Convert to kilometers
  }
}
