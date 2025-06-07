import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: MaterialApp (
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Icon(Icons.water_drop),
            actions: <Widget> [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add)
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list)
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search)
              )
            ], //Text('LiquidLibrary'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.radio_button_unchecked)),
                Tab(icon: Icon(Icons.control_point)),
                Tab(icon: Icon(Icons.check_circle_outline)),
                Tab(icon: Icon(Icons.schedule)),
                Tab(icon: Icon(Icons.highlight_off))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Reading')),
              Center(child: Text('Planned')),
              Center(child: Text('Completed')),
              Center(child: Text('Holded')),
              Center(child: Text('Dropped')),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
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
              )
            ]
          )
        ),
      )
    );
  }
}
