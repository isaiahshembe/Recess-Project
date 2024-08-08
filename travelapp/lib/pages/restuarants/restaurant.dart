import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_map/flutter_map.dart';
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
>>>>>>> 83a203dafc79b61bc85040836b6db88b93916b0b
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
<<<<<<< HEAD
  final List<Marker> _markers = [];
  Position? _currentPosition;
  final String _placesApiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw'; // Replace with your actual API key
  final MapController _mapController = MapController();
  bool _locationFetched = false;
  final TextEditingController _searchController = TextEditingController();
=======
  List<Map<String, dynamic>> _restaurants = [];
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final String _placesApiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw';
>>>>>>> 83a203dafc79b61bc85040836b6db88b93916b0b

  @override
  void initState() {
    super.initState();
    _fetchFirestoreRestaurants();
  }

  Future<void> _fetchFirestoreRestaurants() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('restaurants').get();
      setState(() {
        _restaurants = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching restaurants: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
<<<<<<< HEAD
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
=======
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NearbyRestaurantsPage(
            currentPosition: _currentPosition!,
            placesApiKey: _placesApiKey,
          ),
        ),
      );
    } catch (e) {
      print('Error getting current location: $e');
    }
>>>>>>> 83a203dafc79b61bc85040836b6db88b93916b0b
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
<<<<<<< HEAD
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
=======
            child: _restaurants.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = _restaurants[index];
                      return ListTile(
                        leading: restaurant['image'] != null && restaurant['image'].isNotEmpty
                            ? Image.network(
                                restaurant['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : null,
                        title: Text(restaurant['name']),
                        subtitle: Text(restaurant['address']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailsPage(
                                name: restaurant['name'],
                                address: restaurant['address'],
                                description: restaurant['description'],
                                image: restaurant['image'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: Text('Restaurants Near Me'),
          ),
        ],
      ),
    );
  }
}

class NearbyRestaurantsPage extends StatefulWidget {
  final Position currentPosition;
  final String placesApiKey;

  NearbyRestaurantsPage({
    required this.currentPosition,
    required this.placesApiKey,
  });

  @override
  _NearbyRestaurantsPageState createState() => _NearbyRestaurantsPageState();
}

class _NearbyRestaurantsPageState extends State<NearbyRestaurantsPage> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchNearbyRestaurants();
  }

  Future<void> fetchNearbyRestaurants() async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${widget.currentPosition.latitude},${widget.currentPosition.longitude}&radius=10000&type=restaurant&key=${widget.placesApiKey}';

    if (Platform.isAndroid || Platform.isIOS) {
      // This block will run only on Android or iOS
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'OK') {
            final List<Marker> markers = [];
            for (var result in data['results']) {
              final double lat = result['geometry']['location']['lat'];
              final double lng = result['geometry']['location']['lng'];
              final String name = result['name'];
              final String address = result['vicinity'];

              markers.add(
                Marker(
                  markerId: MarkerId(result['place_id']),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(
                    title: name,
                    snippet: address,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailsPage(
                          name: name,
                          address: address,
                          description: '',
                          image: '',
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            setState(() {
              _markers.clear();
              _markers.addAll(markers);
              _isLoading = false;
              if (_mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(widget.currentPosition.latitude, widget.currentPosition.longitude),
                    12.0,
                  ),
                );
              }
            });
          } else {
            setState(() {
              _errorMessage = data['error_message'] ?? 'Error fetching data';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Failed to fetch data: ${response.reasonPhrase}';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
          _isLoading = false;
        });
        print('Client exception: $e');
      }
    } else {
      // This block will run on other platforms (like Web)
      setState(() {
        _errorMessage = 'This feature is not supported on this platform';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Restaurants'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.currentPosition.latitude,
                      widget.currentPosition.longitude,
                    ),
                    zoom: 12.0,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
>>>>>>> 83a203dafc79b61bc85040836b6db88b93916b0b
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String image;

<<<<<<< HEAD
  const RestaurantDetailsPage({super.key, required this.name, required this.address});
=======
  RestaurantDetailsPage({
    required this.name,
    required this.address,
    required this.description,
    required this.image,
  });
>>>>>>> 83a203dafc79b61bc85040836b6db88b93916b0b

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
            if (image.isNotEmpty)
              Image.network(
                image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
<<<<<<< HEAD
            const SizedBox(height: 8),
=======
            SizedBox(height: 8),
>>>>>>> 83a203dafc79b61bc85040836b6db88b93916b0b
            Text(
              'Address: $address',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
