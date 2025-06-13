import 'package:flutter/material.dart';
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/databases/dbprovider.dart';

class BookAddPage extends StatelessWidget {
  BookAddPage({super.key});
  final _mainFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _cycleController = TextEditingController();
  final _genresController = TextEditingController();
  final _currentPageController = TextEditingController();
  final _totalPagesController = TextEditingController();
  final _coverPathController = TextEditingController();
  final _filePathController = TextEditingController();

  final dbprovider = DBProvider.db;

  void _saveBook() async {
    // if(_mainFormKey.currentState!.validate()) {
      final title = _titleController.text;
      final author = _authorController.text;
      final cycle = _cycleController.text;
      final genres = _genresController.text;
      final currentPage = _currentPageController.text;
      final totalPages = _totalPagesController.text;
      final coverPath = _coverPathController.text;
      final filePath = _filePathController.text;

      final book = Book(
        id: null,
        title: title,
        author: author,
        status: 'Planned',
        cycle: cycle,
        genres: genres,
        currentPage: int.tryParse(currentPage) ?? 0,
        totalPages: int.tryParse(totalPages) ?? 0,
        dateStarted: 'null',
        dateFinished: 'null',
        rating: 0,
        notes: 'null',
        coverPath: coverPath,
        filePath: filePath,
      );

      await dbprovider.addBook(book);
    // }
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Form(
              key: _mainFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title*'),
                    validator: (value) => value == null || value.isEmpty ? 'Enter book title' : null,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(labelText: 'Author'),
                    validator: (value) => null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _currentPageController,
                          decoration: InputDecoration(labelText: 'Current Page'),
                          keyboardType: TextInputType.number,
                          validator: (value) => null,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _totalPagesController,
                          decoration: InputDecoration(labelText: 'Total Pages'),
                          keyboardType: TextInputType.number,
                          validator: (value) => null,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _cycleController,
                    decoration: InputDecoration(labelText: 'Cycle'),
                    validator: (value) => null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Save book',
        onPressed: () {
          _saveBook();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => LibraryPage()),
          // );
          Navigator.pop(context, true);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}