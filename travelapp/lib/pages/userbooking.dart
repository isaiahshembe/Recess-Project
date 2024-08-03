import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:touristapp/pages/car_rentals.dart';

class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({super.key});

  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToAddBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CarRentalContentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past'),
            Tab(text: 'Canceled'),
          ],
          indicatorColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: _navigateToAddBooking,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BookingsList(status: 'Active', emptyMessage: 'Where to next?', emptySubMessage: "You haven't started any trips yet. Once you make a booking, it'll appear here."),
          BookingsList(status: 'Past', emptyMessage: 'Revisit past trips', emptySubMessage: 'Here you can refer to all past trips and get inspiration for your next ones.'),
          BookingsList(status: 'Canceled', emptyMessage: 'Sometimes plans change', emptySubMessage: "Here you can refer to all trips you've cancelled--maybe next time."),
        ],
      ),
    );
  }
}

class BookingsList extends StatelessWidget {
  final String status;
  final String emptyMessage;
  final String emptySubMessage;

  const BookingsList({
    super.key,
    required this.status,
    required this.emptyMessage,
    required this.emptySubMessage,
  });

  Future<void> _cancelBooking(DocumentSnapshot booking) async {
    await FirebaseFirestore.instance
        .collection('car_rental_bookings')
        .doc(booking.id)
        .update({'status': 'Canceled'});
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('car_rental_bookings')
          .where('user_id', isEqualTo: user?.uid)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emptyMessage,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    emptySubMessage,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final data = booking.data() as Map<String, dynamic>;

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                tileColor: Colors.green.shade50,
                title: Text(
                  'Pickup: ${data['pickup_location']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                subtitle: Text(
                  'Pickup Date: ${data['pickup_date']}\n'
                  'Pickup Time: ${data['pickup_time']}\n'
                  'Return Date: ${data['return_date']}\n'
                  'Return Time: ${data['return_time']}\n'
                  'Driver Age: ${data['driver_age_range']['start']}-${data['driver_age_range']['end']}\n'
                  'Destination: ${data['destination_address']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                trailing: status == 'Active'
                    ? Tooltip(
                        message: 'Cancel Trip',
                        child: IconButton(
                          icon: const Icon(Icons.cancel),
                          color: Colors.red,
                          onPressed: () async {
                            await _cancelBooking(booking);
                          },
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
