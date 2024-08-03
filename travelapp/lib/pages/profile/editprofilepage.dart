import 'dart:typed_data' if (kIsWeb) 'dart:typed_data';
import 'dart:io' if (dart.library.io) 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart'
    if (dart.library.io) 'package:image_picker/image_picker.dart' as mobile;
import 'package:image_picker_web/image_picker_web.dart'
    if (kIsWeb) 'package:image_picker_web/image_picker_web.dart' as web;

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  User? user;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  dynamic _image; // Use dynamic type to handle both web and mobile
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phoneNumber);
  }

  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        final pickedFile = await web.ImagePickerWeb
            .getImageAsBytes(); // Use getImageAsBytes for web
        if (pickedFile != null) {
          setState(() {
            _image = pickedFile;
          });
        }
      } else {
        final pickedFile = await mobile.ImagePicker()
            .pickImage(source: mobile.ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _uploadImageAndSaveProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String? downloadURL;
      if (_image != null) {
        if (kIsWeb) {
          // Web: Upload image data
          final bytes = _image as Uint8List; // Directly use Uint8List
          String fileName = 'profile_pictures/${user!.uid}.jpg';
          final uploadTask =
              FirebaseStorage.instance.ref(fileName).putData(bytes);
          final snapshot = await uploadTask;
          downloadURL = await snapshot.ref.getDownloadURL();
        } else {
          // Mobile: Upload file
          String fileName = 'profile_pictures/${user!.uid}.jpg';
          final uploadTask =
              FirebaseStorage.instance.ref(fileName).putFile(_image as File);
          final snapshot = await uploadTask;
          downloadURL = await snapshot.ref.getDownloadURL();
        }

        // Update Firestore user document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'displayName': _nameController!.text,
          'email': _emailController!.text,
          'phoneNumber': _phoneController!.text,
          'photoURL': downloadURL,
        });

        // Update FirebaseAuth user profile
        await user!.updateProfile(
            displayName: _nameController!.text, photoURL: downloadURL);
      } else {
        // If no new image, just update the profile information
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'displayName': _nameController!.text,
          'email': _emailController!.text,
          'phoneNumber': _phoneController!.text,
        });

        await user!.updateProfile(displayName: _nameController!.text);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _uploadImageAndSaveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? (kIsWeb
                              ? MemoryImage(_image as Uint8List) // Web image
                              : FileImage(_image as File)) // Mobile image
                          : (user?.photoURL != null
                                  ? NetworkImage(user!.photoURL!)
                                  : const AssetImage(
                                      'images/default_profile_image.jpg'))
                              as ImageProvider<Object>?,
                      child: _image == null
                          ? const Icon(Icons.camera_alt,
                              size: 50, color: Colors.white70)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: true, // Email is not editable
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadImageAndSaveProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
