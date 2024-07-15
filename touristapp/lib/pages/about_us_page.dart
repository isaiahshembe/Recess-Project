import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(

        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/display_image1.jpg', 
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Go Safari!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'At Go Safari, we are passionate about making your safari experience unforgettable. '
                    'Explore the wild and beautiful landscapes with ease, discover hidden gems, and '
                    'immerse yourself in local culture and wildlife.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                  'Features:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '- Comprehensive information about destinations, attractions, accommodations, and local services.\n'
                  '- Personalized recommendations based on your preferences and current location.\n'
                  '- Real-time updates on weather, events, transportation, and safety alerts.\n'
                  '- Secure user authentication and profile management.\n'
                  '- Offline access to essential information and maps.\n'
                  '- Support for multiple languages.',
                  style: TextStyle(fontSize: 16),
                ),
                  const SizedBox(height: 20),
                  const Text(
                    'Download Go Safari today and embark on your next adventure!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Contact us: info@gosafari.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/display_image1.jpg', 
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Go Safari!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'At Go Safari, we are passionate about making your safari experience unforgettable. '
                  'Explore the wild and beautiful landscapes with ease, discover hidden gems, and '
                  'immerse yourself in local culture and wildlife.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Text(
                'Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Comprehensive information about destinations, attractions, accommodations, and local services.\n'
                '- Personalized recommendations based on your preferences and current location.\n'
                '- Real-time updates on weather, events, transportation, and safety alerts.\n'
                '- Secure user authentication and profile management.\n'
                '- Offline access to essential information and maps.\n'
                '- Support for multiple languages.',
                style: TextStyle(fontSize: 16),
              ),
                const SizedBox(height: 20),
                const Text(
                  'Download Go Safari today and embark on your next adventure!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Contact us: info@gosafari.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}