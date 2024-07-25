import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/pages/admin/admin_page.dart';
 // Import your admin page

class TourismPageEdit extends StatefulWidget {
  const TourismPageEdit({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tourism Place'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name of the Tourism Place',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(
                labelText: 'Image URL of the Tourism Place',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description of the Tourism Place',
              ),
              maxLines: 3, // Adjust according to your design
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location of the Tourism Place',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price of the Tourism Place',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _saveTourismPlace();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTourismPlace() async {
    // Get values from controllers
    String name = _nameController.text.trim();
    String image = _imageController.text.trim();
    String description = _descriptionController.text.trim();
    String location = _locationController.text.trim();
    String price = _priceController.text.trim();

    try {
      // Add a new document with auto-generated ID to "tourism_places" collection
      await FirebaseFirestore.instance.collection('tourism_places').add({
        'name': name,
        'image': image,
        'description': description,
        'location': location,
        'price': double.parse(price), // Convert price to double if necessary
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tourism place saved successfully')),
      );

      // Navigate to AdminPage after saving
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
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
        SnackBar(content: Text('Failed to save tourism place')),
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
