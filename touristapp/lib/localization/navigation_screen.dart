// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:latlong2/latlong.dart';
// import 'dart:async';
// import 'dart:math' as math;
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

// class NavigationScreen extends StatefulWidget {
//   @override
//   _NavigationScreenState createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   final MapController _mapController = MapController();
//   LatLng _curLocation = LatLng(0.333, 32.556);
//   LatLng? _searchedLocation;
//   // Location location = Location(lat: null, lng: null);  // Add this instance

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _initLocation();
//   // }

//   // Future<void> _initLocation() async {
//   //   bool _serviceEnabled;
//   //   PermissionStatus _permissionGranted;
//   //   LocationData _locationData;

//   //   _serviceEnabled = await location.serviceEnabled();
//   //   if (!_serviceEnabled) {
//   //     _serviceEnabled = await location.requestService();
//   //     if (!_serviceEnabled) {
//   //       return;
//   //     }
//   //   }

//   //   _permissionGranted = await location.hasPermission();
//   //   if (_permissionGranted == PermissionStatus.denied) {
//   //     _permissionGranted = await location.requestPermission();
//   //     if (_permissionGranted != PermissionStatus.granted) {
//   //       return;
//   //     }
//   //   }

//   //   _locationData = await location.getLocation();
//   //   setState(() {
//   //     _curLocation = LatLng(_locationData.latitude!, _locationData.longitude!);
//   //   });
//   // }

//   Future<LatLngBounds> getBounds() async {
//     LatLng riderLocation = _curLocation;
//     LatLng? destinationLocation = _searchedLocation;
//     if (destinationLocation == null) {
//       return LatLngBounds.fromPoints([
//         LatLng(riderLocation.latitude - 0.01, riderLocation.longitude - 0.01),
//         LatLng(riderLocation.latitude + 0.01, riderLocation.longitude + 0.01),
//       ]);
//     }
//     double padding = 0.01;
//     double minLat =
//         math.min(riderLocation.latitude, destinationLocation.latitude);
//     double minLng =
//         math.min(riderLocation.longitude, destinationLocation.longitude);
//     double maxLat =
//         math.max(riderLocation.latitude, destinationLocation.latitude);
//     double maxLng =
//         math.max(riderLocation.longitude, destinationLocation.longitude);
//     return LatLngBounds.fromPoints([
//       LatLng(minLat - padding, minLng - padding),
//       LatLng(maxLat + padding, maxLng + padding),
//     ]);
//   }

//   Future<List<LatLng>> getRoute(LatLng start, LatLng? end) async {
//     if (end == null) {
//       return [start];
//     }
//     final apiKey = '5b3ce3597851110001cf62483c98c04e453d4af1b753d2066b16404f';
//     final url =
//         'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = convert.jsonDecode(response.body);
//       final List coordinates = data['features'][0]['geometry']['coordinates'];
//       return coordinates.map((c) => LatLng(c[1], c[0])).toList();
//     } else {
//       throw Exception('Failed to load route');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigation Screen'),
//       ),
//       body: Column(
//         children: [
//           LocationSearch(
//             onSelected: (LatLng location) {
//               setState(() {
//                 _searchedLocation = location;
//               });
//             },
//           ),
//           Expanded(
//             child: FutureBuilder<LatLngBounds>(
//               future: getBounds(),
//               builder: (context, boundsSnapshot) {
//                 if (boundsSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (boundsSnapshot.hasError) {
//                   return Center(child: Text('Error: ${boundsSnapshot.error}'));
//                 } else {
//                   final bounds = boundsSnapshot.data!;
//                   return FutureBuilder<List<LatLng>>(
//                     future: getRoute(_curLocation, _searchedLocation),
//                     builder: (context, routeSnapshot) {
//                       if (routeSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (routeSnapshot.hasError) {
//                         return Center(
//                             child: Text('Error: ${routeSnapshot.error}'));
//                       } else {
//                         final points = routeSnapshot.data!;
//                         return FlutterMap(
//                           mapController: _mapController,
//                           options: MapOptions(
//                             bounds: bounds,
//                             boundsOptions: FitBoundsOptions(
//                               padding: EdgeInsets.all(20),
//                             ),
//                           ),
//                           children: [
//                             TileLayer(
//                               urlTemplate:
//                                   "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                               subdomains: ['a', 'b', 'c'],
//                             ),
//                             MarkerLayer(
//                               markers: [
//                                 Marker(
//                                   width: 150.0,
//                                   height: 150.0,
//                                   point: _curLocation,
//                                   builder: (ctx) => Container(
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           "You",
//                                           style: TextStyle(
//                                             fontSize: 16.0,
//                                             color: Colors.orange,
//                                             backgroundColor: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Icon(
//                                           Icons.location_pin,
//                                           color: Colors.green,
//                                           size: 40.0,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 if (_searchedLocation != null)
//                                   Marker(
//                                     width: 150.0,
//                                     height: 150.0,
//                                     point: _searchedLocation!,
//                                     builder: (ctx) => Container(
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             "Destination",
//                                             style: TextStyle(
//                                               fontSize: 16.0,
//                                               color: Colors.orange,
//                                               backgroundColor: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Icon(
//                                             Icons.location_pin,
//                                             color: Colors.deepPurple,
//                                             size: 40.0,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             PolylineLayer(
//                               polylines: [
//                                 if (_searchedLocation != null)
//                                   Polyline(
//                                     points: points,
//                                     strokeWidth: 4.0,
//                                     color: Colors.blue,
//                                   ),
//                               ],
//                             ),
//                           ],
//                         );
//                       }
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LocationSearch extends StatefulWidget {
//   final Function(LatLng) onSelected;

//   LocationSearch({required this.onSelected});

//   @override
//   _LocationSearchState createState() => _LocationSearchState();
// }

// class _LocationSearchState extends State<LocationSearch> {
//   final TextEditingController _controller = TextEditingController();
//   final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyAVrtXI_gquoH-rU7nZqRgIyKghlI4rodI');
//   List<Prediction> _predictions = [];

//   void _onSearchChanged() {
//     if (_controller.text.isEmpty) {
//       setState(() {
//         _predictions = [];
//       });
//       return;
//     }

//     _places.autocomplete(_controller.text).then((result) {
//       if (result.status == 'OK') {
//         setState(() {
//           _predictions = result.predictions;
//         });
//       } else {
//         setState(() {
//           _predictions = [];
//         });
//       }
//     });
//   }

//   void _onPredictionTap(Prediction prediction) {
//     _places.getDetailsByPlaceId(prediction.placeId!).then((detailResult) {
//       if (detailResult.status == 'OK') {
//         final location = detailResult.result.geometry!.location;
//         final latLng = LatLng(location.lat, location.lng);
//         widget.onSelected(latLng);
//         setState(() {
//           _controller.text = detailResult.result.formattedAddress!;
//           _predictions = [];
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _controller,
//           decoration: InputDecoration(
//             hintText: 'Search for a location',
//           ),
//           onChanged: (value) => _onSearchChanged(),
//         ),
//         if (_predictions.isNotEmpty)
//           Container(
//             height: 200.0,
//             child: ListView.builder(
//               itemCount: _predictions.length,
//               itemBuilder: (context, index) {
//                 final prediction = _predictions[index];
//                 return ListTile(
//                   title: Text(prediction.description!),
//                   onTap: () => _onPredictionTap(prediction),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
