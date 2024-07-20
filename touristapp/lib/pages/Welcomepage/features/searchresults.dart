import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class SearchResultsPage extends StatelessWidget {
  final List<String> selectedFeatures;

  SearchResultsPage(this.selectedFeatures);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('features')
            .where('name', whereIn: selectedFeatures)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No results found'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text(doc['description']),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
