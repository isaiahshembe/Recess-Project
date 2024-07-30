import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/admin/admin_page.dart'; // Import your admin page

class TourismPageEdit extends StatefulWidget {
  const TourismPageEdit({super.key});

  @override
  State<TourismPageEdit> createState() => _TourismPageEditState();
}

class _TourismPageEditState extends State<TourismPageEdit> {
  // Controllers for text editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Focus nodes to manage focus states
  final FocusNode _priceFocusNode = FocusNode();

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
            _buildTextField(_nameController, 'Name of the Tourism Place'),
            const SizedBox(height: 16.0),
            _buildTextField(_imageController, 'Image URL of the Tourism Place'),
            const SizedBox(height: 16.0),
            _buildTextField(
              _descriptionController,
              'Description of the Tourism Place',
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(_locationController, 'Location of the Tourism Place'),
            const SizedBox(height: 16.0),
            _buildTextField(
              _priceController,
              'Price of the Tourism Place',
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 70),
                backgroundColor: const Color.fromARGB(255, 114, 197, 118),
              ),
              onPressed: _saveTourismPlace,
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
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      focusNode: focusNode,
    );
  }

  void _saveTourismPlace() async {
    // Get values from controllers
    String name = _nameController.text.trim();
    String image = _imageController.text.trim();
    String description = _descriptionController.text.trim();
    String location = _locationController.text.trim();
    String priceText = _priceController.text.trim();

    // Simple validation
    if (name.isEmpty || image.isEmpty || description.isEmpty || location.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Try to parse price
    double? price;
    try {
      price = double.parse(priceText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid price format')),
      );
      return;
    }

    try {
      // Add a new document with auto-generated ID to "tourism_places" collection
      await FirebaseFirestore.instance.collection('tourism_places').add({
        'name': name,
        'image': image,
        'description': description,
        'location': location,
        'price': price,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tourism place saved successfully')),
      );

      // Navigate to AdminPage after saving
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );

      // Clear text fields after saving
      _nameController.clear();
      _imageController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _priceController.clear();
    } catch (e) {
      // Handle errors here
      print('Error saving tourism place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save tourism place')),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes when the widget is disposed
    _nameController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }
}
