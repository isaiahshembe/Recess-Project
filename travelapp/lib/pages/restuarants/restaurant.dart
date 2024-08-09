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
  List<Map<String, String>> _restaurants = [];
  Position? _currentPosition;
  final String _placesApiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw'; // Replace with your actual API key
  final MapController _mapController = MapController();
  bool _locationFetched = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isSatelliteView = false;

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
      await fetchNearbyRestaurants();
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
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=10000&type=restaurant&key=$_placesApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Marker> markers = [];
        final List<Map<String, String>> restaurants = [];

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

          restaurants.add({
            'name': name,
            'address': address,
            'imageUrl': 'https://via.placeholder.com/150',
          });
        }

        setState(() {
          _markers.clear();
          _markers.addAll(markers);
          _restaurants = restaurants;
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

  void _toggleMapType() {
    setState(() {
      _isSatelliteView = !_isSatelliteView;
    });
  }

  void _centerOnUserLocation() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        13.0, // Adjust the zoom level as needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: Icon(_isSatelliteView ? Icons.map : Icons.satellite),
            onPressed: _toggleMapType,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnUserLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                minZoom: 13.0,
                maxZoom: 18.0,
                onTap: _onMapTap,
                // Initial center and zoom should be handled in _getCurrentLocation
              ),
              children: [
                TileLayer(
                  urlTemplate: _isSatelliteView
                      ? 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png'
                      : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Handle search functionality
                    print('Search query: ${_searchController.text}');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: _restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _restaurants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        restaurant['imageUrl'] ?? 'https://via.placeholder.com/150',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      restaurant['name'] ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(restaurant['address'] ?? 'No Address'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailsPage(
                            name: restaurant['name'] ?? '',
                            address: restaurant['address'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnUserLocation,
        child: const Icon(Icons.my_location),
        backgroundColor: Colors.green[800],
        tooltip: 'Center on Current Location',
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
        backgroundColor: Colors.green[800],
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
