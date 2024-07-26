import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Ensure GetX package is imported
import 'package:touristapp/pages/admin/hotel_detail_edit.dart';

class HostelsPage extends StatefulWidget {
  const HostelsPage({super.key});

  @override
  State<HostelsPage> createState() => _HostelsPageState();
}

class _HostelsPageState extends State<HostelsPage> {
  // List to hold the fetched data
  List<QueryDocumentSnapshot> _hotels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('hotels').get();
      List<QueryDocumentSnapshot> hotels = snapshot.docs;

      setState(() {
        _hotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching hotels: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch hotels')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteHotel(String hotelId) async {
    try {
      // Delete the document from the "hotels" collection
      await FirebaseFirestore.instance.collection('hotels').doc(hotelId).delete();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel deleted successfully')),
      );

      // Refresh the list of hotels
      _fetchHotels();
    } catch (e) {
      print('Error deleting hotel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete hotel')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hotels.isEmpty
              ? const Center(child: Text('No hotels found'))
              : ListView.builder(
                  itemCount: _hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = _hotels[index].data() as Map<String, dynamic>;
                    final hotelName = hotel['hotel_name'] ?? 'No Name';
                    final hotelId = _hotels[index].id; // Obtain hotel ID

                    return ListTile(
                      title: Text(hotelName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // Confirm deletion
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Hotel'),
                              content: const Text('Are you sure you want to delete this hotel?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            // Proceed with deletion
                            await _deleteHotel(hotelId);
                          }
                        },
                      ),
                      onTap: () {
                        // Navigate to HotelDetailEdit with the hotel ID
                        Get.to(() => HotelDetailEdit(hotelId: hotelId));
                      },
                    );
                  },
                ),
    );
  }
}
