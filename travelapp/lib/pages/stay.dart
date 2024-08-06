import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key});

  @override
  _StaysPageState createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  List<Map<String, dynamic>> stays = [];
  List<Map<String, dynamic>> filteredStays = [];

  @override
  void initState() {
    super.initState();
    _fetchStays();
  }

  Future<void> _fetchStays() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hotels').get();
      List<Map<String, dynamic>> fetchedStays = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final latitude = _getDoubleFromField(data['location']?['latitude']);
        final longitude = _getDoubleFromField(data['location']?['longitude']);
        return {
          'id': doc.id,
          ...data,
          'location': {
            'latitude': latitude,
            'longitude': longitude,
          },
        };
      }).toList();

      setState(() {
        stays = fetchedStays;
        filteredStays = fetchedStays;
      });
    } catch (e) {
      print('Error fetching stays: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching stays: $e')),
      );
    }
  }

  double _getDoubleFromField(dynamic field) {
    if (field is String) {
      return double.tryParse(field) ?? 0.0;
    } else if (field is num) {
      return field.toDouble();
    } else {
      return 0.0;
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in kilometers
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLon = (lon2 - lon1) * pi / 180;
    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
                sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = R * c; // Distance in kilometers
    return distance;
  }

  Future<void> _updateHotelRating(String hotelId, double rating) async {
    try {
      DocumentReference hotelRef = FirebaseFirestore.instance.collection('hotels').doc(hotelId);
      DocumentSnapshot hotelDoc = await hotelRef.get();

      if (hotelDoc.exists) {
        final data = hotelDoc.data() as Map<String, dynamic>;

        // Ensure the ratings field is always a list
        List<dynamic> currentRatings = data['ratings'] is List
            ? List<dynamic>.from(data['ratings'])
            : [];

        currentRatings.add(rating);

        double averageRating = currentRatings.isNotEmpty
            ? currentRatings.cast<double>().reduce((a, b) => a + b) / currentRatings.length
            : 0.0;
        int ratingCount = currentRatings.length;

        await hotelRef.update({
          'ratings': currentRatings,
          'averageRating': averageRating,
          'ratingCount': ratingCount,
        });

        print('Hotel rating updated successfully');
      } else {
        print('Hotel document does not exist');
      }
    } catch (e) {
      print('Error updating hotel rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating hotel rating: $e')),
      );
    }
  }

  void _showStayDetails(BuildContext context, Map<String, dynamic> stay) {
    double rating = 0.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    stay['image'] != null
                        ? Image.network(stay['image'], fit: BoxFit.cover)
                        : Container(
                      height: 200,
                      color: Colors.grey,
                      child: const Icon(Icons.image_not_supported, size: 100),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      stay['hotel_name'] ?? 'No name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stay['description'] ?? 'No description',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        Text(
                          (stay['averageRating'] != null
                              ? stay['averageRating'].toStringAsFixed(1)
                              : '0.0'),
                          style: TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${stay['ratingCount'] ?? 0} ratings)',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${stay['room_cost']?.toString() ?? 'No price'} per night',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rate this hotel:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Update Firestore with the new rating
                        await _updateHotelRating(stay['id'], rating);

                        // Refresh the stay details to reflect the updated rating
                        Navigator.pop(context);
                        setState(() {
                          _fetchStays(); // Reload the stays list
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, // White text color
                      ),
                      child: const Text('Submit Rating'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the booking page for the specific hotel
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(hotel: stay),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, // White text color
                      ),
                      child: const Text('Book Your Room'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _filterStays(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStays = stays;
      } else {
        filteredStays = stays.where((stay) {
          final name = stay['hotel_name']?.toLowerCase() ?? '';
          final description = stay['description']?.toLowerCase() ?? '';
          final lowerQuery = query.toLowerCase();
          return name.contains(lowerQuery) || description.contains(lowerQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stays'),
        backgroundColor: Colors.green, // Green background color for app bar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search stays',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
              ),
              onChanged: _filterStays,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStays.length,
              itemBuilder: (context, index) {
                final stay = filteredStays[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: stay['image'] != null
                        ? Image.network(
                      stay['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    )
                        : const Icon(Icons.image_not_supported, size: 50),
                    title: Text(
                      stay['hotel_name'] ?? 'No name',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stay['description'] ?? 'No description', style: TextStyle(color: Colors.black87)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 16),
                            Text(
                              (stay['averageRating'] != null
                                  ? stay['averageRating'].toStringAsFixed(1)
                                  : '0.0'),
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                        Text(
                          '\$${stay['room_cost']?.toString() ?? 'No price'} per night',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                    onTap: () => _showStayDetails(context, stay),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> hotel;

  const BookingPage({Key? key, required this.hotel}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  int _numberOfNights = 1;

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(Duration(days: 1));
  }

  Future<void> _bookRoom() async {
  if (_formKey.currentState?.validate() ?? false) {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated.')),
        );
        return;
      }

      final hotelBookingRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('hotelBookings')
          .doc(); // Automatically generates a unique ID for the document

      await hotelBookingRef.set({
        'hotelId': widget.hotel['id'],
        'hotelName': widget.hotel['hotel_name'],
        'checkInDate': _checkInDate.toIso8601String(), // Use ISO8601 format
        'checkOutDate': _checkOutDate.toIso8601String(), // Use ISO8601 format
        'numberOfNights': _numberOfNights,
        'roomCost': widget.hotel['room_cost'],
        'totalCost': _numberOfNights * (widget.hotel['room_cost'] ?? 0),
        'status': 'Booked', // or 'Pending', 'Confirmed', etc.
      });

      // Show a success dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking confirmed for ${widget.hotel['hotel_name']}')),
      );

      // Optionally, you could use a dialog to give more detailed feedback
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Booking Confirmed'),
          content: Text('Your booking at ${widget.hotel['hotel_name']} has been confirmed.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error booking room: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking room: ${e.toString()}')),
      );
    }
  }
}


  void _incrementNights() {
    setState(() {
      _numberOfNights++;
      _checkOutDate = _checkInDate.add(Duration(days: _numberOfNights));
    });
  }

  void _decrementNights() {
    if (_numberOfNights > 1) {
      setState(() {
        _numberOfNights--;
        _checkOutDate = _checkInDate.add(Duration(days: _numberOfNights));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Room at ${widget.hotel['hotel_name']}'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check-In Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: '${_checkInDate.toLocal()}'.split(' ')[0],
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _checkInDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null && selectedDate != _checkInDate) {
                    setState(() {
                      _checkInDate = selectedDate;
                      if (_checkOutDate.isBefore(_checkInDate)) {
                        _checkOutDate = _checkInDate.add(Duration(days: 1));
                      }
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Check-In Date',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Check-Out Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: '${_checkOutDate.toLocal()}'.split(' ')[0],
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _checkOutDate,
                    firstDate: _checkInDate.add(Duration(days: 1)),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null && selectedDate != _checkOutDate) {
                    setState(() {
                      _checkOutDate = selectedDate;
                      _numberOfNights = _checkOutDate.difference(_checkInDate).inDays;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select Check-Out Date',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Number of Nights: $_numberOfNights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.red),
                    onPressed: _decrementNights,
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: _incrementNights,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Total Cost: \$${_numberOfNights * (widget.hotel['room_cost'] ?? 0)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _bookRoom,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
