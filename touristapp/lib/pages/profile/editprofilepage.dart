import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  static const routeName = '/profile-edit-screen';

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late String phoneNumber;
  late String countryCode;

  bool _isUpdating = false; // Flag to track the update process

  var isLoading = false;
  var isobx = false;

  File? _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();

    // Dummy data for testing
    nameController.text = "";
    emailController.text = "";
    phoneNumber = "";
    countryCode = "";
    addressController.text = "";
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> getImageGally() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  Widget showUserData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          formField(
            icon: Icons.person,
            controller: nameController,
            inputType: TextInputType.name,
            hint: "name",
          ),
          SizedBox(height: 20.0),
          formField(
            icon: Icons.email,
            controller: emailController,
            inputType: TextInputType.emailAddress,
            hint: "email",
          ),
          SizedBox(height: 20.0),
          phoneField(),
          SizedBox(height: 20.0),
          formField(
            icon: Icons.location_city_rounded,
            controller: addressController,
            inputType: TextInputType.text,
            hint: "address",
          ),
          SizedBox(height: 25.0),
          InkWell(
            onTap: () {
              getImageGally();
            },
            child: Container(
              height: 150.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: _image != null
                  ? Image.file(_image!)
                  : Image.asset("images/display_image1.jpg"),
            ),
          ),
          SizedBox(height: 25.0),
          InkWell(
            onTap: _isUpdating
                ? null
                : () async {
                    setState(() {
                      _isUpdating = true;
                    });

                    // Simulate a delay to mimic an update process
                    await Future.delayed(Duration(seconds: 2));

                    try {
                      Fluttertoast.showToast(
                        msg: "Updated Successfully",
                        backgroundColor: Colors.black87,
                      );
                      Get.back();
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Something went wrong",
                        backgroundColor: Colors.black87,
                      );
                    } finally {
                      setState(() {
                        _isUpdating = false;
                      });
                    }
                  },
            child: Container(
              height: 60.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: _isUpdating
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Center(
                      child: Text(
                        "Update",
                        style: GoogleFonts.courgette(
                          fontSize: 25,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneField() {
    return IntlPhoneField(
      initialCountryCode: 'UG',
      onChanged: (phone) {
        setState(() {
          countryCode = phone.countryCode;
          phoneNumber = phone.number;
        });
      },
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Edit".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: showUserData(),
      ),
    );
  }

  Widget formField({
    required IconData icon,
    required TextEditingController controller,
    required TextInputType inputType,
    required String hint,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
