import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  List<Map<String, dynamic>> _restaurants = [];
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final String _placesApiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: Column(
        children: [
          Expanded(
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
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String image;

  RestaurantDetailsPage({
    required this.name,
    required this.address,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 16),
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
