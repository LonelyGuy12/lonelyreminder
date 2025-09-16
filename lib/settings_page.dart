import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false; // Placeholder for dark mode state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
                // TODO: Implement actual theme toggling
              });
            },
          ),
          ListTile(
            title: const Text('Sign in with Google'),
            onTap: () {
              // TODO: Implement Google Sign-In
              print('Google Sign-In button tapped');
            },
          ),
          // TODO: Add more user settings here
        ],
      ),
    );
  }
}
