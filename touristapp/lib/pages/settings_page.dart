import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristapp/pages/settings/localprovider.dart';
import 'package:touristapp/pages/settings/themeprovider.dart';
import 'package:touristapp/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  final String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title:Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
=======
        title: Text(AppLocalizations.of(context)!.translate('settings')),
      ),
      body: ListView(
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
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
<<<<<<< HEAD
            title: const Text('Push Notifications'),
            trailing: Switch(
              value: _pushNotificationsEnabled,
              onChanged: (value) {
=======
            title: Text(AppLocalizations.of(context)!.translate('language')),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
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
<<<<<<< HEAD
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
               
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Offline Mode'),
            trailing: Switch(
              value: _offlineModeEnabled,
              onChanged: (value) {
                setState(() {
                  _offlineModeEnabled = value;
                  
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Language'),
            onTap: () {
              
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Select Language'),
                    content: const Text('Implement language selection here.'),
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
=======
            title: Text(AppLocalizations.of(context)!.translate('about')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
              );
            },
          ),
          ListTile(
<<<<<<< HEAD
            title: const Text('Feedback and Support'),
            onTap: () {
          
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Feedback and Support'),
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
=======
            title: Text(AppLocalizations.of(context)!.translate('privacyPolicy')),
            onTap: () {
              Get.to(PrivacyPolicyPage());
>>>>>>> 16779a3ac9759173de7cbabb6b8f77eaec2260c6
            },
          ),
        ],
      ),
    );
  }
}
