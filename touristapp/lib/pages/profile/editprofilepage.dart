import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  User? user;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName);
    _emailController = TextEditingController(text: user?.email);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageAndSaveProfile() async {
    if (_image != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Upload image to Firebase Storage
        String fileName = 'profile_pictures/${user!.uid}.jpg';
        UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();

        // Update Firestore user document
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'displayName': _nameController!.text,
          'photoURL': downloadURL,
        }, SetOptions(merge: true));

        // Update FirebaseAuth user profile
        await user!.updateProfile(displayName: _nameController!.text, photoURL: downloadURL);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _uploadImageAndSaveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (user!.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : AssetImage('assets/images/default_profile_image.jpg')) as ImageProvider,
                      child: _image == null
                          ? Icon(Icons.camera_alt, size: 50, color: Colors.white70)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    readOnly: true, // Email is not editable
                  ),
                ],
              ),
            ),
    );
  }
}
