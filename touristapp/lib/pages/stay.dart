import 'package:flutter/material.dart';

class StaysPage extends StatefulWidget {
  @override
  _StaysPageState createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  final List<String> cities = ['Kampala', 'Jinja', 'Mbale', 'Lira', 'Entebbe'];
  late List<String> filteredCities;

  @override
  void initState() {
    super.initState();
    filteredCities = cities;
  }

  void _filterCities(String query) {
    final filtered = cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredCities = filtered;
    });
  }

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
              onChanged: (value) {
                _filterCities(value);
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
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          'images/kampala-sheraton-hotel.jpg', 
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(filteredCities[index]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description of stay in ${filteredCities[index]}'),
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
                          // Implement navigation to stay details
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
