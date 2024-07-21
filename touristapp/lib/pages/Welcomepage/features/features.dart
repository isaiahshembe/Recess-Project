import 'package:flutter/material.dart';
import 'package:touristapp/pages/Welcomepage/features/searchresults.dart';
import 'package:touristapp/utilities/bottom_nav.dart';

class TrendingFeaturesPage extends StatefulWidget {
  const TrendingFeaturesPage({super.key});

  @override
  _TrendingFeaturesPageState createState() => _TrendingFeaturesPageState();
}

class _TrendingFeaturesPageState extends State<TrendingFeaturesPage> {
  final List<String> trendingFeatures = [
    'Feature 1',
    'Feature 2',
    'Feature 3',
    
  ];
  final List<String> selectedFeatures = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Trending Features')),
      body: ListView.builder(
        itemCount: trendingFeatures.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(trendingFeatures[index]),
            value: selectedFeatures.contains(trendingFeatures[index]),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedFeatures.add(trendingFeatures[index]);
                } else {
                  selectedFeatures.remove(trendingFeatures[index]);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchResultsPage(selectedFeatures)));
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
