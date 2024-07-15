import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CarRentalsPage extends StatefulWidget {
  const CarRentalsPage({super.key});

  @override
  _CarRentalsPageState createState() => _CarRentalsPageState();
}

class _CarRentalsPageState extends State<CarRentalsPage> {
  TextEditingController locationController = TextEditingController();
  DateTime? pickupDate;
  DateTime? returnDate;

  void selectPickupDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), 
    );

    if (picked != null && picked != pickupDate) {
      setState(() {
        pickupDate = picked;
      });
    }
  }

  void selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: returnDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), 
    );

    if (picked != null && picked != returnDate) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Rentals'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Pickup Location on Map',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200, 
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(0.3152, 32.5816), 
                  zoom: 10.0, 
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(0.3152, 32.5816), 
                        builder: (ctx) => const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Pickup Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: selectPickupDate,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Pickup Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: pickupDate != null
                              ? '${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}'
                              : '',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: selectReturnDate,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Return Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: returnDate != null
                              ? '${returnDate!.day}/${returnDate!.month}/${returnDate!.year}'
                              : '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  handleSearch();
                },
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleSearch() {
    String location = locationController.text;
    String? pickupDateString = pickupDate != null
        ? '${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}'
        : null;
    String? returnDateString = returnDate != null
        ? '${returnDate!.day}/${returnDate!.month}/${returnDate!.year}'
        : null;

    // Perform validation
    if (location.isEmpty || pickupDate == null || returnDate == null) {
      // Handle validation error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Perform search operation here (e.g., call an API or navigate to search results page)
    // For demonstration, just print search details
    print('Location: $location');
    print('Pickup Date: $pickupDateString');
    print('Return Date: $returnDateString');
  }
}
