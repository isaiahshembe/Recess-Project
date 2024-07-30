import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategoriesPage extends StatelessWidget {
  const AddCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Categories in Firebase'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await updateCategoriesInFirebase();
          },
          child: const Text('Update Categories'),
        ),
      ),
    );
  }

  Future<void> updateCategoriesInFirebase() async {
    // Define categories with descriptions and location details
    final categories = {
      'Historical Sites': [
        {'name': 'Kasubi Tombs', 'description': 'Burial site of Buganda kings, a UNESCO World Heritage Site.', 'location': 'Kasubi, Kampala'},
        {'name': 'Fort Lugard', 'description': 'Historical fort built by the British in Kampala.', 'location': 'Kampala'},
        {'name': 'Gaddafi Mosque', 'description': 'Prominent mosque in Kampala.', 'location': 'Kampala'},
        {'name': 'Uganda Martyrs Shrine', 'description': 'Religious site in Namugongo commemorating the Uganda Martyrs.', 'location': 'Namugongo'},
        {'name': 'Source of the Nile', 'description': 'Historical site where the Nile River begins its journey, located in Jinja.', 'location': 'Jinja'}
      ],
      'Natural Wonders': [
        {'name': 'Bwindi Impenetrable Forest', 'description': 'UNESCO World Heritage Site known for mountain gorillas in the southwest.', 'location': 'South-Western Uganda'},
        {'name': 'Mgahinga Gorilla National Park', 'description': 'Home to gorillas and golden monkeys, also in the southwest.', 'location': 'South-Western Uganda'},
        {'name': 'Murchison Falls', 'description': 'Dramatic waterfall on the Nile River, located in the northwest.', 'location': 'North-Western Uganda'},
        {'name': 'Queen Elizabeth National Park', 'description': 'Known for its diverse wildlife and the Kazinga Channel, located in the southwest.', 'location': 'South-Western Uganda'},
        {'name': 'Mount Elgon', 'description': 'Extinct volcano with stunning landscapes and hiking opportunities in the east.', 'location': 'Eastern Uganda'}
      ],
      'Entertainment': [
        {'name': 'Kampala Serena Hotel', 'description': 'Hosts various entertainment events in Kampala.', 'location': 'Kampala'},
        {'name': 'Theatre Labonita', 'description': 'Venue for live music, drama, and comedy in Kampala.', 'location': 'Kampala'},
        {'name': 'Nile Special Beer Garden', 'description': 'Local entertainment and events in Jinja.', 'location': 'Jinja'},
        {'name': 'Jinja Sailing Club', 'description': 'Recreational activities and entertainment on Lake Victoria in Jinja.', 'location': 'Jinja'},
        {'name': 'Kampala International Conference Centre (KICC) Food Court', 'description': 'Various dining and entertainment options in Kampala.', 'location': 'Kampala'}
      ],
      'Cultural Experiences': [
        {'name': 'Ndere Cultural Centre', 'description': 'Features traditional music and dance in Kampala.', 'location': 'Kampala'},
        {'name': 'Cultural Village in Kabalagala', 'description': 'Offers traditional crafts and experiences in Kampala.', 'location': 'Kampala'},
        {'name': 'Rwenzori Cultural Centre', 'description': 'Insights into the cultures of the Rwenzori region in the west.', 'location': 'Western Uganda'},
        {'name': 'Kabaka’s Palace', 'description': 'Residence of the King of Buganda, offering historical and cultural tours in Kampala.', 'location': 'Kampala'},
        {'name': 'Acholi Cultural Centre', 'description': 'Focuses on the culture of the Acholi people in the north.', 'location': 'Northern Uganda'}
      ],
      'Adventure Activities': [
        {'name': 'White-water Rafting on the Nile', 'description': 'Exciting rafting experiences near Jinja.', 'location': 'Near Jinja'},
        {'name': 'Mountain Gorilla Trekking in Bwindi', 'description': 'Guided treks to observe mountain gorillas in the southwest.', 'location': 'South-Western Uganda'},
        {'name': 'Volcano Climbing in Mgahinga', 'description': 'Trekking on the Virunga volcanoes in the southwest.', 'location': 'South-Western Uganda'},
        {'name': 'Hiking Mount Elgon', 'description': 'Challenging hikes and beautiful scenery in the east.', 'location': 'Eastern Uganda'},
        {'name': 'Zip-lining in Mabira Forest', 'description': 'Adventure through the canopy of Mabira Forest Reserve in central Uganda.', 'location': 'Central Uganda'}
      ],
      'Family-Friendly': [
        {'name': 'Entebbe Zoo', 'description': 'Great place for families to see various animals in Entebbe.', 'location': 'Entebbe'},
        {'name': 'Wildlife Education Centre (UWEC)', 'description': 'Focuses on wildlife conservation and education in Entebbe.', 'location': 'Entebbe'},
        {'name': 'National Theatre', 'description': 'Offers family-friendly shows and performances in Kampala.', 'location': 'Kampala'},
        {'name': 'Jinja’s Source of the Nile', 'description': 'Family-friendly boat rides and activities in Jinja.', 'location': 'Jinja'},
        {'name': 'Kidepo Valley National Park', 'description': 'Provides a tranquil environment for family safaris in the northeast.', 'location': 'Northeastern Uganda'}
      ],
      'Art and Exhibitions': [
        {'name': 'National Gallery of Uganda', 'description': 'Displays Ugandan art and exhibitions in Kampala.', 'location': 'Kampala'},
        {'name': 'Makerere University Art Gallery', 'description': 'Features contemporary art by Ugandan and African artists in Kampala.', 'location': 'Kampala'},
        {'name': 'Kampala Art Gallery', 'description': 'Showcases local art and crafts in Kampala.', 'location': 'Kampala'},
        {'name': 'Rwenzori Art Gallery', 'description': 'Features art and crafts from the Rwenzori region in the west.', 'location': 'Western Uganda'},
        {'name': 'Entebbe Cultural Centre', 'description': 'Exhibits traditional art and crafts in Entebbe.', 'location': 'Entebbe'}
      ],
      'Dining and Shopping': [
        {'name': 'Café Javas', 'description': 'Popular for dining and coffee in Kampala.', 'location': 'Kampala'},
        {'name': 'Garden City Mall', 'description': 'A major shopping center with diverse dining options in Kampala.', 'location': 'Kampala'},
        {'name': 'The Boma Hotel Restaurant', 'description': 'Offers dining with a view of Lake Victoria in Entebbe.', 'location': 'Entebbe'},
        {'name': 'Jinja Market', 'description': 'Local shopping and dining experiences in Jinja.', 'location': 'Jinja'},
        {'name': 'Igongo Cultural Centre Restaurant', 'description': 'Offers dining with a focus on local cuisine in Mbarara.', 'location': 'Mbarara'}
      ],
      'Relaxation and Wellness': [
        {'name': 'Speke Resort Munyonyo', 'description': 'A luxury resort with spa facilities on the shores of Lake Victoria in Kampala.', 'location': 'Kampala'},
        {'name': 'Sheraton Kampala Hotel Spa', 'description': 'Offers relaxation and wellness treatments in Kampala.', 'location': 'Kampala'},
        {'name': 'Protea Hotel by Marriott Entebbe', 'description': 'Known for its wellness services and lakeside views in Entebbe.', 'location': 'Entebbe'},
        {'name': 'Jinja Nile Resort', 'description': 'Offers a relaxing environment with spa facilities in Jinja.', 'location': 'Jinja'},
        {'name': 'Agip Motel', 'description': 'Provides relaxation and wellness services in Mbarara.', 'location': 'Mbarara'}
      ],
      'Nightlife': [
        {'name': 'Club Silk', 'description': 'A popular nightclub with music and dancing in Kampala.', 'location': 'Kampala'},
        {'name': 'Sky Lounge', 'description': 'Rooftop bar offering drinks and views in Kampala.', 'location': 'Kampala'},
        {'name': 'The Square', 'description': 'Known for its vibrant nightlife and live music in Kampala.', 'location': 'Kampala'},
        {'name': 'The Hangar Lounge Bar', 'description': 'Popular spot for nightlife and socializing in Entebbe.', 'location': 'Entebbe'},
        {'name': 'Jinja Sailing Club', 'description': 'Known for night events and social gatherings in Jinja.', 'location': 'Jinja'}
      ],
      'Sports and Recreation': [
        {'name': 'Kampala Golf Club', 'description': 'Offers golfing and sports facilities in Kampala.', 'location': 'Kampala'},
        {'name': 'Namboole Stadium', 'description': 'Hosts major sports events in Kampala.', 'location': 'Kampala'},
        {'name': 'Jinja Rowing Club', 'description': 'Provides rowing and water sports in Jinja.', 'location': 'Jinja'},
        {'name': 'Mbarara Sports Complex', 'description': 'Facilities for various sports and recreation in Mbarara.', 'location': 'Mbarara'},
        {'name': 'Entebbe Golf Club', 'description': 'Provides golf and recreational activities in Entebbe.', 'location': 'Entebbe'}
      ],
      'Landmarks': [
        {'name': 'The Independence Monument', 'description': 'Commemorates Uganda’s independence in Kampala.', 'location': 'Kampala'},
        {'name': 'Kampala Clock Tower', 'description': 'A notable landmark in the city of Kampala.', 'location': 'Kampala'},
        {'name': 'Uganda Martyrs Shrine', 'description': 'A significant religious landmark in Namugongo.', 'location': 'Namugongo'},
        {'name': 'Source of the Nile', 'description': 'Historical landmark where the Nile begins in Jinja.', 'location': 'Jinja'},
        {'name': 'Mbarara Hill', 'description': 'Offers panoramic views of the city and surrounding areas in Mbarara.', 'location': 'Mbarara'}
      ]
    };

    final firestore = FirebaseFirestore.instance;

    for (var category in categories.entries) {
      final categoryName = category.key;
      final places = category.value;

      final collectionRef = firestore.collection('preferences').doc(categoryName).collection('places');

      for (var place in places) {
        // Use the place's name to update the existing document
        final querySnapshot = await collectionRef.where('name', isEqualTo: place['name']).get();

        if (querySnapshot.docs.isNotEmpty) {
          final docId = querySnapshot.docs.first.id;
          final docRef = collectionRef.doc(docId);

          await docRef.update({
            'description': place['description'],
            'location': place['location'],
          });
        } else {
          print('Place "${place['name']}" not found in category "$categoryName"');
        }
      }
    }

    print('Categories and places updated in Firebase successfully');
  }
}
