import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelAdd extends StatefulWidget {
  const HotelAdd({super.key});

  @override
  State<HotelAdd> createState() => _HotelAddState();
}

class _HotelAddState extends State<HotelAdd> {
  // Controllers for text editing
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _roomCostController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String? _selectedTourismPlace;
  List<String> _tourismPlaces = [];

  @override
  void initState() {
    super.initState();
    _fetchTourismPlaces();
  }

  Future<void> _fetchTourismPlaces() async {
    try {
      // Fetch tourism places from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('tourism_places').get();
      List<String> tourismPlaces = snapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _tourismPlaces = tourismPlaces;
        if (_tourismPlaces.isNotEmpty) {
          _selectedTourismPlace = _tourismPlaces[0];
        }
      });
    } catch (e) {
      print('Error fetching tourism places: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch tourism places')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel'),
      ),
      body: SingleChildScrollView(
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
              onPressed: _saveHotel,
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

  void _saveHotel() async {
    String hotelName = _hotelNameController.text.trim();
    String roomCostText = _roomCostController.text.trim();
    String imageUrl = _imageController.text.trim();
    String description = _descriptionController.text.trim();
    
    // Simple validation
    if (hotelName.isEmpty || _selectedTourismPlace == null || roomCostText.isEmpty || imageUrl.isEmpty || description.isEmpty) {
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
      // Add a new document with auto-generated ID to "hotels" collection
      await FirebaseFirestore.instance.collection('hotels').add({
        'hotel_name': hotelName,
        'tourism_place': _selectedTourismPlace,
        'room_cost': roomCost,
        'image': imageUrl,
        'description': description,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel added successfully')),
      );

      // Clear text fields after saving
      _hotelNameController.clear();
      _roomCostController.clear();
      _imageController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedTourismPlace = _tourismPlaces.isNotEmpty ? _tourismPlaces[0] : null;
      });
    } catch (e) {
      // Handle errors here
      print('Error saving hotel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save hotel')),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _hotelNameController.dispose();
    _roomCostController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
