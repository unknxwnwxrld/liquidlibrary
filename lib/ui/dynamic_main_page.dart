import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/book_card.dart';
import 'package:liquidlibrary/ui/instance_sources_page.dart';
import 'package:liquidlibrary/ui/instance_edit_page.dart';

// Импортируем модель и провайдер базы (путь подкорректируйте под свой проект)
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/database/database.dart';

class DynamicMainPage extends StatefulWidget {
  const DynamicMainPage({super.key});

  @override
  State<DynamicMainPage> createState() => _DynamicMainPageState();
}

class _DynamicMainPageState extends State<DynamicMainPage> {
  int _selectedIndex = 0;

  Future<List<Book>> _booksFuture = DBProvider.db.getAllBooks();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFuture = DBProvider.db.getAllBooks();
    });
  }

  List<List<Widget>> _buildActions(BuildContext context) => [
        [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InstanceEditPage(bookId: null),
                ),
              ).then((value) {
                if (value == true) {
                  _loadBooks();
                }
              });
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
    Center(child: Text('Profile')),
    Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLibraryTabView() {
    return TabBarView(
      children: [
        // Первый таб — список книг из базы
        FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Your library is empty'));
            } else {
              final books = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: BookCard(
                      title: book.title,
                      author: book.author,
                      coverPath: book.coverPath,
                      currentPage: book.currentPage,
                      totalPages: book.totalPages,
                      bookId: book.id, // <-- добавьте эту строку!
                    ),
                  );
                },
              );
            }
          },
        ),

        // Остальные табы — заглушки, как было
        Center(child: Text('Planned')),
        Center(child: Text('Completed')),
        Center(child: Text('Holded')),
        Center(child: Text('Dropped')),
      ],
    );
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
              ? _buildLibraryTabView()
              : _pages[_selectedIndex - 1], // -1, т.к. _pages без Library

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
