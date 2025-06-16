import 'package:flutter/material.dart';
import 'home_page.dart';
import 'library_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {setState(() {currentPageIndex = index;});},
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          // Home
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // Library
          NavigationDestination(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          // Profile
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // Settings
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: [
        HomePage(),
        LibraryPage(),
        ProfilePage(),
        SettingsPage(),
      ][currentPageIndex],
    );
  }
}