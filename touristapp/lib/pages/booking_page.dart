// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   final MapController _mapController = MapController();
//   final List<Marker> _markers = [];
//   final TextEditingController _searchController = TextEditingController();

//   // Sample carousel items
//   final List<Map<String, dynamic>> carouselItems = [
//     {'image': 'images/kampala-sheraton-hotel.jpg', 'caption': 'Cozy Hotels'},
//     {'image': 'images/kidepo.jpeg', 'caption': 'Tourist Attractions'},
//     {'image': 'images/murchision.jpg', 'caption': 'Beautiful Accommodation'},
//     {'image': 'images/westnile.jpeg', 'caption': 'Scenic Mountains'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Map/Booking'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search for a place',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: _searchPlace,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//                 options: MapOptions(
//                   center: LatLng(0.3152, 32.5816), 
//                   zoom: 10.0, 
                  
//                 ),
//                 children: [
//                   TileLayer(
//                     urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     subdomains: const ['a', 'b', 'c'],
//                   ),
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         width: 80.0,
//                         height: 80.0,
//                         point: LatLng(0.3152, 32.5816), 
//                         builder: (ctx) => const Icon(
//                           Icons.location_pin,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: _bookPlace,
//               child: const Text('Book this place'),
//             ),
//           ),
//           SizedBox(
//             height: 200,
//             child: CarouselSlider.builder(
//               itemCount: carouselItems.length,
//               options: CarouselOptions(
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 viewportFraction: 0.8,
//                 aspectRatio: 16 / 9,
//                 autoPlayCurve: Curves.fastOutSlowIn,
//                 autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                 enableInfiniteScroll: true,
//                 autoPlayInterval: const Duration(seconds: 3),
//                 pauseAutoPlayOnTouch: true,
//                 scrollDirection: Axis.horizontal,
//               ),
//               itemBuilder: (BuildContext context, int index, int realIndex) {
//                 return Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 5.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     image: DecorationImage(
//                       image: AssetImage(carouselItems[index]['image']!),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       carouselItems[index]['caption']!,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addMarker,
//         child: const Icon(Icons.add_location),
//       ),
//     );
//   }

//   void _handleTap(LatLng latlng) {
//     final marker = Marker(
//       width: 80.0,
//       height: 80.0,
//       point: latlng,
//       builder: (ctx) => const Icon(
//         Icons.location_on,
//         color: Colors.red,
//         size: 40.0,
//       ),
//     );

//     setState(() {
//       _markers.add(marker);
//     });
//   }

//   void _addMarker() {
//     final marker = Marker(
//       width: 80.0,
//       height: 80.0,
//       point: LatLng(
//         -33.865143 + (_markers.length * 0.01),
//         151.209900 + (_markers.length * 0.01),
//       ),
//       builder: (ctx) => const Icon(
//         Icons.location_on,
//         color: Colors.red,
//         size: 40.0,
//       ),
//     );

//     setState(() {
//       _markers.add(marker);
//     });
//   }

//   void _searchPlace() async {
//     final query = _searchController.text;
//     if (query.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a place to search')),
//       );
//       return;
//     }

//     try {
//       final List<Location> locations = await locationFromAddress(query);

//       if (locations.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No locations found')),
//         );
//         return;
//       }

//       // Clear existing markers before adding new ones
//       _markers.clear();

//       final location = locations.first;
//       final latlng = LatLng(location.latitude, location.longitude);

//       _mapController.move(latlng, 15.0);

//       final marker = Marker(
//         width: 80.0,
//         height: 80.0,
//         point: latlng,
//         builder: (ctx) => const Icon(
//           Icons.location_on,
//           color: Colors.blue,
//           size: 40.0,
//         ),
//       );

//       setState(() {
//         _markers.add(marker);
//       });
//     } catch (e) {
//       print('Error searching place: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error searching place: $e')),
//       );
//     }
//   }

//   void _bookPlace() {
//     if (_markers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No place selected for booking')),
//       );
//       return;
//     }

//     // Handle the booking logic here
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Place booked successfully!')),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> stay;

  const BookingPage({Key? key, required this.stay}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final List<Map<String, dynamic>> _nearbyStays = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyStays();
  }

  Future<void> _fetchNearbyStays() async {
    try {
      final latitude = widget.stay['location']['latitude'];
      final longitude = widget.stay['location']['longitude'];
      const radiusInKm = 10.0; // Radius to fetch nearby stays

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Places')
          .get();

      final stays = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((stay) => stay.containsKey('location') && stay['location'].containsKey('latitude') && stay['location'].containsKey('longitude'))
          .toList();

      final nearbyStays = stays.where((stay) {
        final stayLatitude = stay['location']['latitude'];
        final stayLongitude = stay['location']['longitude'];
        final distance = _calculateDistance(latitude, longitude, stayLatitude, stayLongitude);
        return distance <= radiusInKm;
      }).toList();

      setState(() {
        _nearbyStays.clear();
        _nearbyStays.addAll(nearbyStays);
      });
    } catch (e) {
      print('Error fetching nearby stays: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // Pi / 180
    final double a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) *
      (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R * asin...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stay['name'] ?? 'Unknown Stay'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _nearbyStays.length,
              itemBuilder: (context, index) {
                final stay = _nearbyStays[index];
                return ListTile(
                  title: Text(stay['name'] ?? 'Unknown Name'),
                  subtitle: Text('${stay['description'] ?? 'No description'} - ${stay['price']?.toString() ?? 'N/A'}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(stay: stay),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
