import 'package:cloud_firestore/cloud_firestore.dart';

class StayService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addStay(Map<String, dynamic> stayData) async {
    await _firestore.collection('Places').add({
      'name': stayData['name'],
      'description': stayData['description'],
      'price': stayData['price'],
      'averageRating': stayData['averageRating'],
      'image': stayData['image'],
      'location': {
        'latitude': stayData['latitude'],
        'longitude': stayData['longitude'],
      },
    });
  }

  // Add other methods related to stays here
}
