import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/database/database.dart';

class InstanceEditPage extends StatefulWidget {
  final int? bookId; // id книги, если редактируем

  const InstanceEditPage({Key? key, this.bookId}) : super(key: key);

  @override
  _InstanceEditPageState createState() => _InstanceEditPageState();
}

class _InstanceEditPageState extends State<InstanceEditPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _author = '';
  String _coverPath = '';
  int _currentPage = 0;
  int _totalPages = 0;
  String _tag = 'Reading'; // <-- добавьте это

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.bookId != null) {
      _loadBook();
    }
  }

  Future<void> _loadBook() async {
    setState(() => _isLoading = true);
    final books = await DBProvider.db.getAllBooks();
    final book = books.firstWhere(
      (b) => b.id == widget.bookId,
      orElse: () => Book(id: null, title: '', author: '', coverPath: '', currentPage: 0, totalPages: 0, tag: 'Reading'),
    );
    setState(() {
      _title = book.title;
      _author = book.author;
      _coverPath = book.coverPath;
      _currentPage = book.currentPage;
      _totalPages = book.totalPages;
      _tag = book.tag; // <-- загружаем тег
      _isLoading = false;
    });
  }

  Future<void> _pickCover() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _coverPath = picked.path;
      });
    }
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final book = Book(
      id: widget.bookId,
      title: _title,
      author: _author,
      coverPath: _coverPath,
      currentPage: _currentPage,
      totalPages: _totalPages,
      tag: _tag, // Provide a value or add a field for tag if needed
    );

    if (widget.bookId == null) {
      await DBProvider.db.insertBook(book);
    } else {
      await DBProvider.db.updateBook(book);
    }
    Navigator.pop(context, true);
  }

  Future<void> _deleteBook() async {
    if (widget.bookId != null) {
      await DBProvider.db.deleteBook(widget.bookId!);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId == null ? 'Add Book' : 'Edit Book'),
        actions: widget.bookId != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Book'),
                        content: const Text('Are you sure you want to delete this book?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _deleteBook();
                    }
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _pickCover,
                child: _coverPath.isEmpty
                    ? Container(
                        height: 140,
                        color: Colors.grey[300],
                        child: const Center(child: Text('Tap to select cover')),
                      )
                    : Image.file(
                        File(_coverPath),
                        height: 140,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                initialValue: _title,
                onSaved: (value) => _title = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                initialValue: _author,
                onSaved: (value) => _author = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter an author' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Current Page'),
                initialValue: _currentPage.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _currentPage = int.tryParse(value ?? '') ?? 0,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  if (v == null || v < 0) return 'Enter a valid page number';
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Total Pages'),
                initialValue: _totalPages.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _totalPages = int.tryParse(value ?? '') ?? 0,
                validator: (value) {
                  final v = int.tryParse(value ?? '');
                  if (v == null || v <= 0) return 'Enter a valid total pages';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _tag,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  'Reading',
                  'Planned',
                  'Complete',
                  'Holded',
                  'Dropped',
                ].map((tag) => DropdownMenuItem(
                      value: tag,
                      child: Text(tag),
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    _tag = value!;
                  });
                },
                onSaved: (value) => _tag = value ?? 'Reading',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: Text(widget.bookId == null ? 'Add Book' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}