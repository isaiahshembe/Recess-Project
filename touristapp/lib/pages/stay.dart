import 'package:flutter/material.dart';

class StaysPage extends StatefulWidget {
  @override
  _StaysPageState createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stays'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search stays',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                // Implement search functionality
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChip(
                  label: Text('Price'), 
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
                FilterChip(
                  label: Text('Rating'),
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
                FilterChip(
                  label: Text('Location'),
                  onSelected: (bool value) {
                    // Implement filter functionality
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with your data count
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.network(
                          'images/kampala-sheraton-hotel.jpg', 
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text('Stay ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description of stay ${index + 1}'),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 16),
                                Text('4.5'), 
                              ],
                            ),
                            Text('\$100 per night'), 
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Implement navigation to map view
              },
              icon: Icon(Icons.map),
              label: Text('View on Map'),
            ),
          ),
        ],
      ),
    );
  }
}

