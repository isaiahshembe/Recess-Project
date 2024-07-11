import 'package:flutter/material.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [
    {
      'name': 'Murchison Falls',
      'location': 'Masindi',
      'image': 'images/muchison.jpg',
      'rating': 4,
      'type': 'Nature',
    },
    {
      'name': 'Lake Mburo',
      'location': 'Toro',
      'image': 'images/muchison.jpg',
      'rating': 4,
      'type': 'Nature',
    },
    {
      'name': 'Queen Elizabeth',
      'location': 'Masindi',
      'image': 'images/muchison.jpg',
      'rating': 3,
      'type': 'Nature',
    },
    // Add more items here
  ];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems; // Initially, display all items
  }

  void _filterResults(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      results = allItems;
    } else {
      results = allItems
          .where((item) =>
              item['name']!.toLowerCase().contains(query.toLowerCase()) ||
              item['location']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredItems = _rankResults(results, query);
    });
  }

  List<Map<String, dynamic>> _rankResults(List<Map<String, dynamic>> results, String query) {
    // Example ranking logic: rank by rating
    results.sort((a, b) => b['rating'].compareTo(a['rating']));
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'images/display_image1.jpg',
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      hintText: 'What are you looking for?',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _filterResults(_searchController.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onChanged: (text) {
                      _filterResults(text);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended for you',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: filteredItems.map((item) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          height: 160,
                          width: 150,
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(item['image']),
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                item['location'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < item['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: index < item['rating']
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
