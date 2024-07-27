import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  ResultsPage({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: results.isEmpty
          ? Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                var place = results[index];
                return ListTile(
                  title: Text(place['name']),
                  subtitle: Text(
                      'Distance: ${(place['distance'] / 1000).toStringAsFixed(2)} km'),
                );
              },
            ),
    );
  }
}
