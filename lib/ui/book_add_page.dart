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

//currentPage == totalPages ? 'Complete' : 'Planned',

      final book = Book(
        id: null,
        title: title,
        author: author,
        status: (int.tryParse(currentPage) ?? 0) == (int.tryParse(totalPages) ?? 0)
          ? 'Complete'
          : ((int.tryParse(currentPage) ?? 0) > 0
          ? 'Reading'
          : 'Planned'
        ),
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
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the title of the book";
                      }
                      return null;
                    },
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
                          validator: (value) {
                            if(value == null || value == '') {
                              return "Must be at least 0";
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _totalPagesController,
                          decoration: InputDecoration(labelText: 'Total Pages'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final currentPage = int.tryParse(_currentPageController.text);
                            final totalPages = int.tryParse(value ?? '');
                            if (value == null || value == "" || currentPage == null || totalPages == null || currentPage > totalPages) {
                              return 'Must be greater than or equal to current page';
                            }
                            return null;
                          },
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
          if (_mainFormKey.currentState!.validate()){
            _saveBook();
            Navigator.pop(context, true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}