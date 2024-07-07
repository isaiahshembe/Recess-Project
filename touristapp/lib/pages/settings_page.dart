import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _offlineModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text('Push Notifications'),
            trailing: Switch(
              value: _pushNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _pushNotificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Dark Mode'),
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
            title: Text('Offline Mode'),
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
            title: Text('Language'),
            onTap: () {
              
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Language'),
                    content: Text('Implement language selection here.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
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
          ListTile(
            title: Text('Feedback and Support'),
            onTap: () {
          
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Feedback and Support'),
                    content: Text('Implement feedback and support options here.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
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
  
        ],
      ),
    );
  }
}


