import 'package:flutter/material.dart';
import 'package:touristapp/pages/car_rentals.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const DetailScreen({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    final String placeName = place.containsKey('hotel_name')
        ? place['hotel_name']
        : place.containsKey('name')
            ? place['name']
            : 'No name';
    final String? location = place['location'];

    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
        backgroundColor: Colors.green[800], 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            place['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      place['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
            const SizedBox(height: 16),
            Text(
              placeName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              place['description'] ?? 'No description',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            if (location != null)
              Text(
                'Location: $location',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              const Text(
                'Location information is not available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            const Spacer(), // This will push the button to the bottom
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarRentalContentPage(place: place),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800], // Match the theme color
                  minimumSize: const Size(200, 50), // Set a specific button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Visit Place',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
