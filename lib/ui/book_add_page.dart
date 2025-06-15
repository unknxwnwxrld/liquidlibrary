import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/widgets/image_picker.dart';
import 'package:liquidlibrary/databases/dbprovider.dart';

class BookAddPage extends StatefulWidget {
  final Book? book; // если null — добавление, если не null — редактирование

  const BookAddPage({Key? key, this.book}) : super(key: key);

  @override
  BookAddPageState createState() => BookAddPageState();
}


class BookAddPageState extends State<BookAddPage> {
  final _mainFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _cycleController = TextEditingController();
  final _genresController = TextEditingController();
  final _currentPageController = TextEditingController();
  final _totalPagesController = TextEditingController();
  final _filePathController = TextEditingController();
  String _coverPath = '';
  final dbprovider = DBProvider.db;
  String? _titleErrorText;
  String? _currentPageErrorText;
  String? _totalPagesErrorText;

  Future<void> _saveBook() async {
    final title = _titleController.text;
    final author = _authorController.text;
    final cycle = _cycleController.text;
    final genres = _genresController.text;
    final currentPage = _currentPageController.text;
    final totalPages = _totalPagesController.text;
    final coverPath = _coverPath;
    final filePath = _filePathController.text;

    final book = Book(
      id: widget.book?.id, // если редактируем — сохраняем id
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
      dateStarted: widget.book?.dateStarted ?? 'null',
      dateFinished: widget.book?.dateFinished ?? 'null',
      rating: widget.book?.rating ?? 0,
      notes: widget.book?.notes ?? 'null',
      coverPath: coverPath,
      filePath: filePath,
    );

    if (widget.book == null) {
      await dbprovider.addBook(book);
    } else {
      await dbprovider.updateBook(book);
    }
  }


  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author ?? '';
      _cycleController.text = widget.book!.cycle ?? '';
      _genresController.text = widget.book!.genres ?? '';
      _currentPageController.text = widget.book!.currentPage.toString();
      _totalPagesController.text = widget.book!.totalPages.toString();
      _coverPath = widget.book!.coverPath ?? '';
      _filePathController.text = widget.book!.filePath ?? '';
    }
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomImagePicker(
              coverPath: _coverPath,
              onImagePicked: (path) {
                setState(() {
                  _coverPath = path;
                });
              },
            ),
            Form(
              key: _mainFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title', errorText: _titleErrorText),
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        setState(() {
                          _titleErrorText = null;
                        });
                        return;
                      }
                      if(value == '') {
                        setState(() {
                          _titleErrorText = 'Enter book title';
                        });
                      }
                    },
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
                          decoration: InputDecoration(labelText: 'Current Page', errorText: _currentPageErrorText),
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            if(value.isEmpty) {
                              setState(() {
                                _currentPageErrorText = null;
                              });
                            }

                            final intValue = int.tryParse(value);

                            if (intValue == null) {
                              setState(() {
                                _currentPageErrorText = 'Enter correct number';
                              });
                              return;
                            }

                            final totalPages = int.tryParse(_totalPagesController.text);

                            if (intValue < 0 || (totalPages != null && intValue > totalPages)) {
                              setState(() {
                                _currentPageErrorText = 'Must be less than ${totalPages ?? "∞"}';
                              });
                              return;
                            }

                            // Если все проверки пройдены — сбрасываем ошибку и сохраняем значение в базу
                            setState(() {
                              _currentPageErrorText = null;
                            });
                          },
                          validator: (value) {
                            if(value == null || value == '') {
                              return "Must be at least 0";
                            }
                          }
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _totalPagesController,
                          decoration: InputDecoration(labelText: 'Total Pages', errorText: _totalPagesErrorText),
                          keyboardType: TextInputType.number,
                          onChanged: (value) async {
                            if (value.isEmpty) {
                              setState(() {
                                _totalPagesErrorText = null;
                              });
                              return;
                            }

                            final currentPage = int.tryParse(_currentPageController.text);
                            final totalPages = int.tryParse(value);

                            if (totalPages == null) {
                              setState(() {
                                _totalPagesErrorText = 'Enter correct number';
                              });
                              return;
                            }

                            if(int.tryParse(_currentPageController.text) == null) {
                              setState(() {
                                _currentPageErrorText = 'Enter correct number';
                              });
                            }

                            if (currentPage == null || totalPages < 0 || currentPage > totalPages) {
                              setState(() {
                                _totalPagesErrorText = 'Enter correct total pages';
                              });
                              return;
                            }

                            setState(() {
                              _totalPagesErrorText = null;
                            });
                          },
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
        tooltip: widget.book == null ? 'Save book' : 'Edit book',
        onPressed: () async {
          if (_mainFormKey.currentState!.validate()){
            await _saveBook(); // дождаться сохранения!
            Navigator.pop(context, true);
          }
        },
        child: widget.book == null ? const Icon(Icons.add) : const Icon(Icons.save),
      ),
    );
  }
}