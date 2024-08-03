import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required double latitude, required double longitude});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  final LatLng _initialPosition =
      const LatLng(0.347596, 32.582520);
  LatLng? _selectedPosition;
  double? _latitude;
  double? _longitude;
  LatLng? _currentPosition;
  List<String> _nearbyPlaces = []; // List to store nearby places

  final List<Map<String, dynamic>> carouselItems = [
    {'image': 'images/kampala-sheraton-hotel.jpg', 'caption': 'Cozy Hotels'},
    {'image': 'images/kidepo.jpeg', 'caption': 'Tourist Attractions'},
    {'image': 'images/murchision.jpg', 'caption': 'Beautiful Accommodation'},
    {'image': 'images/westnile.jpeg', 'caption': 'Scenic Mountains'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _currentPosition = LatLng(_latitude!, _longitude!);
        _mapController.move(
            _currentPosition!, 13.0); // Move the map to the current position
        _getAddressFromLatLng(_latitude!, _longitude!);
        _fetchNearbyPlaces(_latitude!, _longitude!); // Fetch nearby places
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled; handle this case appropriately
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permissions are not granted; handle this case appropriately
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        _addressController.text = address;
      }
    } catch (e) {
      print(e);
    }
  }

  void _searchPlace() async {
    final query = _addressController.text;
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address to search')),
      );
      return;
    }

    try {
      final List<Location> locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No locations found')),
        );
        return;
      }

      final location = locations.first;
      final latlng = LatLng(location.latitude, location.longitude);

      setState(() {
        _selectedPosition = latlng;
        _latitude = location.latitude;
        _longitude = location.longitude;
        _mapController.move(latlng, 15.0);
        _getAddressFromLatLng(_latitude!, _longitude!);
        _fetchNearbyPlaces(_latitude!, _longitude!); // Fetch nearby places
      });
    } catch (e) {
      print('Error searching place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching place: $e')),
      );
    }
  }

  void _bookPlace() async {
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No location selected for booking')),
      );
      return;
    }

    // Replace with actual save address logic
    await _saveAddress(
      _addressController.text,
      _latitude!,
      _longitude!,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Place booked successfully!')),
    );
  }

  Future<void> _saveAddress(
      String address, double latitude, double longitude) async {
    // Dummy implementation; replace with actual save address logic
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
      _latitude = position.latitude;
      _longitude = position.longitude;
      _getAddressFromLatLng(_latitude!, _longitude!);
      _fetchNearbyPlaces(_latitude!, _longitude!); // Fetch nearby places
    });
  }

  Future<void> _fetchNearbyPlaces(double latitude, double longitude) async {
    // Replace this with actual API call
    // For now, we're just using dummy data
    setState(() {
      _nearbyPlaces = [
        'Attraction 1 - ${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
        'Attraction 2 - ${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
        'Attraction 3 - ${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  minZoom: 13.0,
                  maxZoom: 13.0,
                  onTap: _onMapTap,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      if (_currentPosition != null)
                        Marker(
                          width: 30.0,
                          height: 30.0,
                          point: _currentPosition!,
                          child:
                              const Icon(Icons.my_location, color: Colors.blue),
                        ),
                      if (_selectedPosition != null)
                        Marker(
                          width: 30.0,
                          height: 30.0,
                          point: _selectedPosition!,
                          child:
                              const Icon(Icons.location_on, color: Colors.red),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // TextField(
            //   controller: _addressController,
            //   decoration: const InputDecoration(labelText: 'Address'),
            // ),
            const SizedBox(height: 10),
            // ElevatedButton(
            //     onPressed: _searchPlace, child: const Text('Search')),
            ElevatedButton(
                onPressed: _bookPlace, child: const Text('Book Place')),
            if (_latitude != null && _longitude != null)
              Text("Latitude: $_latitude, Longitude: $_longitude"),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: CarouselSlider.builder(
                itemCount: carouselItems.length,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enableInfiniteScroll: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  pauseAutoPlayOnTouch: true,
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(carouselItems[index]['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        carouselItems[index]['caption']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            if (_nearbyPlaces.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _nearbyPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_nearbyPlaces[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
