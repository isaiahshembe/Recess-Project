import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildSectionTitle(context, 'Frequently Asked Questions'),
          _buildFAQItem(
            context,
            'How to use the app?',
            'To use the app, simply navigate through the various sections using the bottom navigation bar. Each section provides specific functionalities.',
          ),
          _buildFAQItem(
            context,
            'How to change the language?',
            'You can change the language in the settings page by selecting your preferred language from the dropdown menu.',
          ),
          _buildFAQItem(
            context,
            'How to contact support?',
            'You can contact our support team through the Contact Us section below.',
          ),
          const SizedBox(height: 24.0),
          _buildSectionTitle(context, 'Contact Us'),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: const Text('info@sofari.com'),
            onTap: () {
              _launchEmail('info@sofari.com');
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: const Text('+256 752 160171'),
            onTap: () {
              _launchPhone('+256 752 160171');
            },
          ),
          const SizedBox(height: 24.0),
          _buildSectionTitle(context, 'More Help'),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Visit our support website'),
            onTap: () {
              _launchWebsite('https://github.com/isaiahshembe/Recess-Project');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(answer),
        ),
      ],
    );
  }

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    try {
      await launch(emailLaunchUri.toString());
    } catch (e) {
      // Handle the exception
      print('Could not launch email');
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    try {
      await launch(phoneLaunchUri.toString());
    } catch (e) {
      // Handle the exception
      print('Could not launch phone');
    }
  }

  void _launchWebsite(String url) async {
    try {
      await launch(url);
    } catch (e) {
      // Handle the exception
      print('Could not launch website');
    }
  }
}
