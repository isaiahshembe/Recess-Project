import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:touristapp/pages/about_us_page.dart';
import 'package:touristapp/pages/privacy_policy_page.dart';
import 'package:touristapp/pages/settings/localprovider.dart';
import 'package:touristapp/pages/settings/themeprovider.dart';
import 'package:touristapp/l10n/app_localizations.dart';
import 'package:touristapp/pages/login_screen.dart'; // Import your login screen

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() {
    // Fetch the current user's email from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';
      });
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Error logging out: $e');
      // Handle error logging out
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.translate('enableNotifications')),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.translate('darkMode')),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleDarkMode(value);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.translate('language')),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                  localeProvider.setLocale(Locale(
                    _selectedLanguage == 'English' ? 'en' : 'es',
                  ));
                });
              },
              items: <String>['English', 'Spanish']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.translate('about')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.translate('privacyPolicy')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.translate('feedbackSupport')),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.translate('feedbackSupport')),
                    content: const Text('Implement feedback and support options here.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Logged in as: $_userEmail',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.translate('logout'),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              _logout();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
