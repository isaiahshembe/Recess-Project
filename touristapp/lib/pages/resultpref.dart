import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  const ResultsScreen({required this.results, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: results.isEmpty
          ? Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  leading: result['image'] != null 
                    ? Image.network(
                        result['image'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : Container(width: 50, height: 50, color: Colors.grey), // Placeholder for missing images
                  title: Text(result['name'] ?? 'No name'),
                  subtitle: Text(result['description'] ?? 'No description'),
                );
              },
            ),
    );
  }
}
