import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/book_card.dart';
import 'package:liquidlibrary/ui/instance_sources_page.dart';
import 'package:liquidlibrary/ui/instance_edit_%D0%B7age.dart';

class DynamicMainPage extends StatefulWidget {
  const DynamicMainPage({super.key});

  @override
  State<DynamicMainPage> createState() => _DynamicMainPageState();
}

class _DynamicMainPageState extends State<DynamicMainPage> {
  int _selectedIndex = 0;

  List<List<Widget>> _buildActions(BuildContext context) => [
    [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstanceEditPage(instanceId: 'new')),
          );
        },
        icon: Icon(Icons.add),
      ),
      IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)),
      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
    ],
    [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
    []
  ];

  final List<Widget> _pages = [
    Center(child: Text('Library')),
    Center(child: Text('Profile')),
    Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Icon(Icons.water_drop),
            actions: _buildActions(context)[_selectedIndex],
            bottom: _selectedIndex == 0
            ? const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.radio_button_unchecked)),
                  Tab(icon: Icon(Icons.control_point)),
                  Tab(icon: Icon(Icons.check_circle_outline)),
                  Tab(icon: Icon(Icons.schedule)),
                  Tab(icon: Icon(Icons.highlight_off)),
                ],
              )
            : null,
          ),

          body: _selectedIndex == 0
          ? TabBarView(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: BookCard(
                    title: 'Very very very long book title',
                    author: 'Very very very long book author',
                    coverUrl:'assets/images/book_cover_placeholder.png',
                    currentPage: 100,
                    totalPages: 300,
                  ),
                ),
                Center(child: Text('Planned')),
                Center(child: Text('Completed')),
                Center(child: Text('Holded')),
                Center(child: Text('Dropped')),
              ],
            )
          : _pages[_selectedIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}