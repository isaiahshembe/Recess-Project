import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchTourismPlaces() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tourism_places').get();
    List<Map<String, dynamic>> places = querySnapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();
    return places;
  } catch (e) {
    print('Error fetching tourism places: $e');
    return [];
  }
}
