import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final List<Marker> _markers = [];
  Position? _currentPosition;
  final String _placesApiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw'; // Replace with your actual API key
  final MapController _mapController = MapController();
  bool _locationFetched = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Current Position: $_currentPosition'); // Debugging line
      if (_currentPosition != null) {
        _mapController.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          13.0,
        );
      }
      fetchNearbyRestaurants();
      setState(() {
        _locationFetched = true;
      });
    } catch (e) {
      print('Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting current location')),
      );
    }
  }

 Future<void> fetchNearbyRestaurants() async {
  if (_currentPosition == null) return;

  final String url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=10000&type=restaurant&key=AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw';

  try {
    final response = await http.get(Uri.parse(url));
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Marker> markers = [];
      for (var result in data['results']) {
        final double lat = result['geometry']['location']['lat'];
        final double lng = result['geometry']['location']['lng'];
        final String name = result['name'];
        final String address = result['vicinity'];

        markers.add(
          Marker(
            point: LatLng(lat, lng),
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailsPage(
                      name: name,
                      address: address,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.restaurant,
                color: Colors.red,
              ),
            ),
          ),
        );
      }

      setState(() {
        _markers.clear();
        _markers.addAll(markers);
      });
    } else {
      print('API Request Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch restaurants: ${response.statusCode}'),
        ),
      );
    }
  } catch (e) {
    print('Error fetching nearby restaurants: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching nearby restaurants: $e'),
      ),
    );
  }
}

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    // Handle map tap if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
        backgroundColor: Colors.green[800], // Match the theme color
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                minZoom: 13.0,
                maxZoom: 13.0,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (_currentPosition != null)
                      Marker(
                        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                        width: 30.0,
                        height: 30.0,
                        child: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ..._markers,
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for restaurants',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Handle search functionality
                    // You might want to filter the markers or make a new API call based on the search query
                    print('Search query: ${_searchController.text}');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  final String name;
  final String address;

  const RestaurantDetailsPage({super.key, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green[800], // Match the theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: $address',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
