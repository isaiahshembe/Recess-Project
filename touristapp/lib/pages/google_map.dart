import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

<<<<<<< HEAD:touristapp/lib/pages/booking_page.dart
class _BookingPageState extends State<BookingPage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map/Booking'),
=======
class _GoogleMapPageState extends State<GoogleMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text('Google map page'),
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6:touristapp/lib/pages/google_map.dart
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for a place',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchPlace,
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(-33.865143, 151.209900),
                zoom: 10.0,
                onTap: _handleTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _markers,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _bookPlace,
              child: const Text('Book this place'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        child: const Icon(Icons.add_location),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    final marker = Marker(
      width: 80.0,
      height: 80.0,
      point: latlng,
      builder: (ctx) => const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40.0,
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _addMarker() {
    final marker = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(
        -33.865143 + (_markers.length * 0.01),
        151.209900 + (_markers.length * 0.01),
      ),
      builder: (ctx) => const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40.0,
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _searchPlace() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latlng = LatLng(location.latitude, location.longitude);

        _mapController.move(latlng, 15.0);

        final marker = Marker(
          width: 80.0,
          height: 80.0,
          point: latlng,
          builder: (ctx) => const Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 40.0,
          ),
        );

        setState(() {
          _markers.add(marker);
        });
      }
    } catch (e) {
      print('Error searching place: $e');
    }
  }

  void _bookPlace() {
    if (_markers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No place selected for booking')),
      );
      return;
    }

    // Handle the booking logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Place booked successfully!')),
    );
  }
}
