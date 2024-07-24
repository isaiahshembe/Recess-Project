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
    'Kampala',
    'Jinja',
    'FortPortal',
    'Entebbe',
    
  ];
  final List<String> selectedFeatures = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Trending Features'),
      centerTitle: true,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Top visited and best tour areas',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
          ),
        ],
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
