import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final TextEditingController _searchController = TextEditingController();

  // Sample carousel items
  final List<Map<String, dynamic>> carouselItems = [
    {'image': 'images/kampala-sheraton-hotel.jpg', 'caption': 'Cozy Hotels'},
    {'image': 'images/kidepo.jpeg', 'caption': 'Tourist Attractions'},
    {'image': 'images/murchision.jpg', 'caption': 'Beautiful Accommodation'},
    {'image': 'images/westnile.jpeg', 'caption': 'Scenic Mountains'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map/Booking'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _bookPlace,
              child: const Text('Book this place'),
            ),
          ),
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
                scrollDirection: Axis.horizontal,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        child: const Icon(Icons.add_location),
      ),
    );
  }

  void _handleTap(LatLng latlng) {
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
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a place to search')),
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

      // Clear existing markers before adding new ones
      _markers.clear();

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
    } catch (e) {
      print('Error searching place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching place: $e')),
      );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
