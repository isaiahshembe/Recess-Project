import 'package:flutter/material.dart';
import 'package:touristapp/pages/more/Events.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Options'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Shopping'),
            onTap: () {
              // Navigate to Shopping Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_parking),
            title: const Text('Parking'),
            onTap: () {
              // Navigate to Parking Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Tour Guides'),
            onTap: () {
              // Navigate to Tour Guides Page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Information'),
            onTap: () {
              // Navigate to Information Page
            },
          ),
        ],
      ),
    );
  }
}
