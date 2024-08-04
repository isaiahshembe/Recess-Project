import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/booking_page.dart';
import 'package:touristapp/tourism_place.dart';

class TourismDetailsPage extends StatelessWidget {
  final TourismPlace place;
  final List<TourismPlace> nearbyPlaces;
  final Function(double) onRate;

  const TourismDetailsPage({
    super.key,
    required this.place,
    required this.nearbyPlaces,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                place.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              place.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              place.location,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              place.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Price: \$${place.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Rating: ${place.rating.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16.0),
            RatingBar.builder(
              initialRating: place.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                onRate(rating);
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _navigateToBookingScreen(context, place);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Book Now'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      latitude: place.latitude,
                      longitude: place.longitude,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('View on Map'),
            ),
            // Optional: Display nearby places if needed
          ],
        ),
      ),
    );
  }

  void _navigateToBookingScreen(BuildContext context, TourismPlace place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(place: place),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final TourismPlace place;

  const BookingScreen({
    super.key,
    required this.place,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Debit Card';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.place.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Location: ${widget.place.location}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Price: \$${widget.place.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount to pay',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: <String>['Debit Card', 'Mobile Money'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _confirmBooking(context, widget.place, _amountController.text, _selectedPaymentMethod);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context, TourismPlace place, String amount, String paymentMethod) async {
    double? paymentAmount = double.tryParse(amount);
    if (paymentAmount != null && paymentAmount > 0) {
      // Get the current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Store booking details in Firestore under the user's document
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('bookings').add({
          'place': place.name,
          'location': place.location,
          'price': place.price,
          'amountPaid': paymentAmount,
          'paymentMethod': paymentMethod,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking confirmed for ${place.name} with \$${paymentAmount.toStringAsFixed(2)} using $paymentMethod!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
    }
  }
}
