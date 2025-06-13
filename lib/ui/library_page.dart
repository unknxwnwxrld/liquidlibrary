import 'package:flutter/material.dart';
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/databases/dbprovider.dart';
import 'package:liquidlibrary/widgets/library_book_card.dart';
import 'package:liquidlibrary/ui/book_add_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final dbprovider = DBProvider.db;
  final List<String> _statuses = ['Reading', 'Planned', 'Complete', 'Holded', 'Dropped'];
  late List<Future<List<Book>>> _booksFutures;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _booksFutures = _statuses.map((status) => DBProvider.db.getBooksByStatus(status)).toList();
    });
  }

  void _navigateToAddBookPage() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BookAddPage()),
  );

  // Если result == true, значит книга добавлена — обновляем список
  if (result == true) {
    _loadBooks();
    setState(() {}); // Обновляем UI
  }
}


  Widget _buildLibraryTabView() {
    _booksFutures = _statuses.map((status) => DBProvider.db.getBooksByStatus(status)).toList();
    return TabBarView(
      children: List.generate(_statuses.length, (tabIndex) {
        return FutureBuilder<List<Book>>(
          future: _booksFutures[tabIndex],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No books in this section'));
            } else {
              final books = snapshot.data!.reversed.toList();
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Padding(
                    padding: const EdgeInsets.all(0),
                    child: LibraryBookCard(
                      
                      title: book.title,
                      author: book.author ?? 'Unknown Author',
                      coverPath: book.coverPath,
                    )
                  );
                },
              );
            }
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _statuses.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.radio_button_unchecked)),
              Tab(icon: Icon(Icons.control_point)),
              Tab(icon: Icon(Icons.check_circle_outline)),
              Tab(icon: Icon(Icons.schedule)),
              Tab(icon: Icon(Icons.highlight_off)),
            ],
          ),
        ),
        body: _buildLibraryTabView(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _navigateToAddBookPage();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => BookAddPage()),
            // );
          },
          tooltip: 'New book',
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}