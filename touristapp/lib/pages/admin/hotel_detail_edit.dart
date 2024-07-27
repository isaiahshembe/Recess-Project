import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelDetailEdit extends StatefulWidget {
  final String hotelId; // Add a parameter for the hotel ID

  const HotelDetailEdit({super.key, required this.hotelId});

  @override
  State<HotelDetailEdit> createState() => _HotelDetailEditState();
}

class _HotelDetailEditState extends State<HotelDetailEdit> {
  // Controllers for text editing
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _roomCostController = TextEditingController();
  String? _selectedTourismPlace;
  List<String> _tourismPlaces = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTourismPlaces();
    _fetchHotelDetails();
  }

  Future<void> _fetchTourismPlaces() async {
    try {
      // Fetch tourism places from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tourism_places').get();
      List<String> tourismPlaces = snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _tourismPlaces = tourismPlaces;
      });
    } catch (e) {
      print('Error fetching tourism places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch tourism places')),
      );
    }
  }

  Future<void> _fetchHotelDetails() async {
    try {
      // Fetch hotel details from Firestore using the hotel ID
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('hotels').doc(widget.hotelId).get();
      if (snapshot.exists) {
        var hotel = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _hotelNameController.text = hotel['hotel_name'] ?? '';
          _imageController.text = hotel['image'] ?? '';
          _descriptionController.text = hotel['description'] ?? '';
          _roomCostController.text = hotel['room_cost']?.toString() ?? '';
          _selectedTourismPlace = hotel['tourism_place'] ?? (_tourismPlaces.isNotEmpty ? _tourismPlaces[0] : null);
          _isLoading = false;
        });
      } else {
        print('Hotel not found');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel not found')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching hotel details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch hotel details')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateHotelDetails() async {
    String hotelName = _hotelNameController.text.trim();
    String imageUrl = _imageController.text.trim();
    String description = _descriptionController.text.trim();
    String roomCostText = _roomCostController.text.trim();
    String? tourismPlace = _selectedTourismPlace;

    // Simple validation
    if (hotelName.isEmpty || imageUrl.isEmpty || description.isEmpty || roomCostText.isEmpty || tourismPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Try to parse room cost
    double? roomCost;
    try {
      roomCost = double.parse(roomCostText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid room cost format')),
      );
      return;
    }

    try {
      // Update the document in the "hotels" collection
      await FirebaseFirestore.instance.collection('hotels').doc(widget.hotelId).update({
        'hotel_name': hotelName,
        'image': imageUrl,
        'description': description,
        'room_cost': roomCost,
        'tourism_place': tourismPlace,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel details updated successfully')),
      );
    } catch (e) {
      print('Error updating hotel details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update hotel details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Hotel Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(_hotelNameController, 'Name of the Hotel'),
                  const SizedBox(height: 16.0),
                  _buildTextField(_imageController, 'Hotel Image URL'),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    _descriptionController,
                    'Hotel Description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16.0),
                  _buildDropdown(),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    _roomCostController,
                    'Cost of a Hotel Room Per Night',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 70),
                      backgroundColor: const Color.fromARGB(255, 114, 197, 118),
                    ),
                    onPressed: _updateHotelDetails,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper method for building TextFormFields
  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    int? maxLines,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  // Helper method for building DropdownButton
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTourismPlace,
      hint: const Text('Select Tourism Place'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTourismPlace = newValue;
        });
      },
      items: _tourismPlaces.map((place) {
        return DropdownMenuItem<String>(
          value: place,
          child: Text(place),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Tourism Place',
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _hotelNameController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _roomCostController.dispose();
    super.dispose();
  }
}
