import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RestaurantsPage extends StatefulWidget {
  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final String _placesApiKey = 'AIzaSyBqFSXCGCI-kbhD66qO34OqMNbtClURZLw'; // API key here

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
      fetchNearbyRestaurants();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchNearbyRestaurants() async {
    if (_currentPosition == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=10000&type=restaurant&key=$_placesApiKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

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
      if (_mapController != null && _currentPosition != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            12.0,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
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

  RestaurantDetailsPage({required this.name, required this.address});

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
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
