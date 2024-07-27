import 'package:flutter/material.dart';
import 'package:touristapp/pages/details.dart';

class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  const ResultsScreen({required this.results, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tailored Insights')),
      body: results.isEmpty
          ? const Center(child: Text('No results found'))
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result['description'] ?? 'No description'),
                      // if (result['location'] != null) 
                      //   Text(
                      //     'Location: ${result['location']}',
                      //     style: TextStyle(color: Colors.grey[600]), // Optional styling
                      //   ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          place: result,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
