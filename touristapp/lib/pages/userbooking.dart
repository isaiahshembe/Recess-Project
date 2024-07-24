import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:touristapp/pages/car_rentals.dart';

class UserBookingsPage extends StatefulWidget {
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
      MaterialPageRoute(builder: (context) => CarRentalContentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active'),
            Tab(text: 'Past'),
            Tab(text: 'Canceled'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddBooking,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
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

  BookingsList({required this.status, required this.emptyMessage, required this.emptySubMessage});

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
          return Center(child: CircularProgressIndicator());
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
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    emptySubMessage,
                    style: TextStyle(fontSize: 16.0),
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

            return ListTile(
              title: Text('Pickup: ${data['pickup_location']}'),
              subtitle: Text(
                'Pickup Date: ${data['pickup_date']}\n'
                'Pickup Time: ${data['pickup_time']}\n'
                'Return Date: ${data['return_date']}\n'
                'Return Time: ${data['return_time']}\n'
                'Driver Age: ${data['driver_age_range']['start']}-${data['driver_age_range']['end']}',
              ),
              trailing: status == 'Active' 
                  ? Tooltip(
                      message: 'Cancel Trip',
                      child: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () async {
                          await _cancelBooking(booking);
                        },
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
