import 'package:flutter/material.dart';
import 'package:lonelyreminder/services/google_auth_service.dart';
import 'package:lonelyreminder/providers/theme_provider.dart';
import 'package:lonelyreminder/services/calendar_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GoogleAuthService _authService = GoogleAuthService();
  final CalendarService _calendarService = CalendarService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    _currentUser = await _authService.getCurrentUser();
    if (mounted) setState(() {});
  }

  Future<void> _signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        setState(() {
          _currentUser = user;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as ${user.displayName}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    setState(() {
      _currentUser = null;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed out successfully')),
    );
  }

  Future<void> _importFromGoogleCalendar() async {
    if (_currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in with Google first')),
      );
      return;
    }

    try {
      final googleEvents = await _calendarService.getUpcomingEvents();
      await _calendarService.importEvents(googleEvents);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imported ${googleEvents.length} events from Google Calendar')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),

          const Divider(),

          // Account Section
          if (_currentUser != null) ...[
            ListTile(
              title: Text('Signed in as ${_currentUser!.displayName ?? _currentUser!.email}'),
              leading: CircleAvatar(
                backgroundImage: _currentUser!.photoURL != null
                    ? NetworkImage(_currentUser!.photoURL!)
                    : null,
                child: const Icon(Icons.account_circle),
              ),
            ),
            ListTile(
              title: const Text('Import from Google Calendar'),
              onTap: _importFromGoogleCalendar,
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: _signOut,
            ),
          ] else ...[
            ListTile(
              title: const Text('Sign in with Google'),
              onTap: _signInWithGoogle,
            ),
          ],

          const Divider(),

          // Additional Settings
          ListTile(
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Lonely Reminder',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
