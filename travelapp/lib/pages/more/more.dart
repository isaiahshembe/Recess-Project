import 'package:flutter/material.dart';
import 'package:touristapp/pages/more/Events.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Options'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shopping'),
            onTap: () {
              // Navigate to Shopping Page
            },
          ),
          ListTile(
            leading: Icon(Icons.local_parking),
            title: Text('Parking'),
            onTap: () {
              // Navigate to Parking Page
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Tour Guides'),
            onTap: () {
              // Navigate to Tour Guides Page
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Information'),
            onTap: () {
              // Navigate to Information Page
            },
          ),
        ],
      ),
    );
  }
}
