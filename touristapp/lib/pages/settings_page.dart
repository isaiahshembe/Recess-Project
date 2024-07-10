import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:touristapp/pages/about_us_page.dart';
import 'package:touristapp/pages/privacy_policy_page.dart';
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
  String _selectedLanguage = 'English';

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
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.translate('privacyPolicy')),
            onTap: () {
              Get.to(() => PrivacyPolicyPage());
            },
          ),
        ],
      ),
    );
  }
}
