import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package

class TourismPageEdit extends StatefulWidget {
  final Map<String, dynamic> initialData; // Initial data from Firestore
  final String documentId; // Document ID for Firestore document

  const TourismPageEdit({super.key, required this.initialData, required this.documentId});

  @override
  State<TourismPageEdit> createState() => _TourismPageEditState();
}

class _TourismPageEditState extends State<TourismPageEdit> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with initial data
    _nameController.text = widget.initialData['name'] ?? '';
    _imageController.text = widget.initialData['image'] ?? '';
    _descriptionController.text = widget.initialData['description'] ?? '';
    _locationController.text = widget.initialData['location'] ?? '';
    _priceController.text = widget.initialData['price'].toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tourism Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              labelText: 'Name of the Tourism Place',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _imageController,
              labelText: 'Image URL of the Tourism Place',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _descriptionController,
              labelText: 'Description of the Tourism Place',
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _locationController,
              labelText: 'Location of the Tourism Place',
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              controller: _priceController,
              labelText: 'Price of the Tourism Place',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 70),
                backgroundColor: const Color.fromARGB(255, 114, 197, 118),
              ),
              onPressed: () {
                _saveChanges();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Grey fill color
        borderRadius: BorderRadius.circular(27.0), // Circular border radius
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          labelText: labelText,
          border: InputBorder.none, // Remove the default border
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }

  void _saveChanges() async {
    // Get updated values from controllers
    String name = _nameController.text.trim();
    String image = _imageController.text.trim();
    String description = _descriptionController.text.trim();
    String location = _locationController.text.trim();
    String price = _priceController.text.trim();

    try {
      // Update the document in Firestore
      await FirebaseFirestore.instance.collection('tourism_places').doc(widget.documentId).update({
        'name': name,
        'image': image,
        'description': description,
        'location': location,
        'price': double.parse(price), // Convert price to double if necessary
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );

      // Optionally, navigate back to previous page after saving
      Navigator.pop(context);
    } catch (e) {
      // Handle errors here
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save changes')),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _nameController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
