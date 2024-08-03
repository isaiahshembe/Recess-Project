import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _locationsCollection = _firestore.collection('locations');

  static Future<void> saveAddress(String address, double latitude, double longitude) async {
    try {
      await _locationsCollection.add({
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving address: $e');
    }
  }
}
