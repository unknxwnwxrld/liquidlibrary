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
  final _formKeyMain = GlobalKey<FormState>();
  final _formKeyDetails = GlobalKey<FormState>();

  String _title = '';
  String _author = '';
  String _coverPath = '';
  int _currentPage = 0;
  int _totalPages = 0;
  String _tag = 'Reading'; // Инициализируем значением по умолчанию

  bool _isLoading = false;

  // Список тегов вынесем для удобства
  final List<String> _bookTags = const ['Reading', 'Planned', 'Complete', 'Holded', 'Dropped'];

  final Map<String, IconData> _tagIcons = const {
    'Reading': Icons.radio_button_unchecked,
    'Planned': Icons.control_point,
    'Complete': Icons.check_circle_outline,
    'Holded': Icons.schedule,
    'Dropped': Icons.highlight_off,
  };

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
    // Добавим проверку, что книга найдена
    final book = books.firstWhere(
          (b) => b.id == widget.bookId,
      // Используем null, чтобы можно было проверить, была ли книга найдена
      // или передаем дефолтный Book, если так задумано для создания новой, если ID не найден
      orElse: () => Book(id: null, title: '', author: '', coverPath: '', currentPage: 0, totalPages: 0, tag: 'Reading'),
    );

    // Если книга реально редактируется (т.е. book.id не null после поиска)
    // или если orElse всегда возвращает валидный Book для инициализации
    setState(() {
      _title = book.title;
      _author = book.author;
      _coverPath = book.coverPath;
      _currentPage = book.currentPage;
      _totalPages = book.totalPages;
      // Убедимся, что загруженный тег есть в нашем списке, иначе используем дефолтный
      _tag = _bookTags.contains(book.tag) ? book.tag : _bookTags.first;
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
    // Валидируем обе формы
    final isMainFormValid = _formKeyMain.currentState?.validate() ?? false;
    final isDetailsFormValid = _formKeyDetails.currentState?.validate() ?? false;

    if (isMainFormValid && isDetailsFormValid) {
      _formKeyMain.currentState!.save();
      _formKeyDetails.currentState!.save(); // _tag будет сохранен здесь, если FormField используется правильно

      final book = Book(
        id: widget.bookId,
        title: _title,
        author: _author,
        coverPath: _coverPath,
        currentPage: _currentPage,
        totalPages: _totalPages,
        tag: _tag,
      );

      if (widget.bookId == null) {
        await DBProvider.db.insertBook(book);
      } else {
        await DBProvider.db.updateBook(book);
      }
      if (mounted) { // Проверка, что виджет все еще в дереве
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _deleteBook() async {
    if (widget.bookId != null) {
      await DBProvider.db.deleteBook(widget.bookId!);
      if (mounted) { // Проверка, что виджет все еще в дереве
        Navigator.pop(context, true);
      }
    }
  }

  // Функция для отображения модального окна выбора тега
  Future<void> _showTagPicker(FormFieldState<String> field) async {
    final String? selectedTag = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _bookTags.map((tagString) { // Переименовал 'tag' в 'tagString' для ясности
              return ListTile(
                leading: Icon( // <--- Добавляем иконку слева
                  _tagIcons[tagString] ?? Icons.label_outline, // Используем иконку из карты или дефолтную
                  color: _tag == tagString ? Theme.of(context).primaryColor : null, // Цвет иконки при выборе
                ),
                title: Text(tagString),
                onTap: () {
                  Navigator.pop(context, tagString);
                },
                selected: _tag == tagString,
                selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedTag != null) {
      setState(() {
        _tag = selectedTag;
      });
      field.didChange(selectedTag);
    } else {
      field.didChange(_tag);
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
            icon: const Icon(Icons.delete_outline),
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
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 120,
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: GestureDetector(
                          onTap: _pickCover,
                          child: _coverPath.isEmpty
                              ? Container(
                            width: 100,
                            height: 134,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_search, size: 40, color: Colors.grey),
                          )
                              : Image.file(
                            File(_coverPath),
                            height: 134,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _formKeyMain,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Title', border: InputBorder.none),
                            initialValue: _title,
                            onSaved: (value) => _title = value ?? '',
                            validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter a title' : null,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Author', border: InputBorder.none),
                            initialValue: _author,
                            onSaved: (value) => _author = value ?? '',
                            validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter an author' : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 119.0),
                            child: SizedBox(
                              width: 150,
                              child: FormField<String>(
                                key: ValueKey<String>('tag_form_field_$_tag'),
                                initialValue: _tag,
                                onSaved: (value) {
                                  _tag = value ?? _bookTags.first;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty || !_bookTags.contains(value)) {
                                    return 'Please select a valid tag';
                                  }
                                  return null;
                                },
                                builder: (FormFieldState<String> field) {
                                  // ... остальная часть вашего builder
                                  final currentTagValue = field.value ?? _bookTags.first;
                                  final currentIconData = _tagIcons[currentTagValue] ?? Icons.label_outline;

                                  return InkWell(
                                    // ... onTap
                                    onTap: () async {
                                      field.didChange(currentTagValue);
                                      await _showTagPicker(field);
                                    },
                                    child: InputDecorator(
                                      // ... decoration
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                        errorText: field.errorText,
                                      ),
                                      child: Row(
                                        // ... children
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded( // <--- Добавьте Expanded здесь, если текст может быть длинным
                                            child: Row(
                                              children: [
                                                Icon(
                                                  currentIconData,
                                                  size: 20,
                                                  color: Colors.grey[700],
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded( // <--- И здесь, чтобы текст не выходил за рамки
                                                  child: Text(
                                                    currentTagValue.isEmpty ? 'Select Tag' : currentTagValue,
                                                    overflow: TextOverflow.ellipsis, // Обрезать текст, если он слишком длинный
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded ( // Обернул вторую часть в Expanded, чтобы ListView мог корректно работать внутри Column
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                // Убрал SizedBox с фиксированной высотой, чтобы ListView мог скроллиться, если контента много
                child: Form(
                  key: _formKeyDetails,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150, // Можно сделать гибче через Expanded
                            height: 75,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(38.0), // Сделал радиус чуть меньше для эстетики
                              ),
                            ),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Current',
                                ),
                                initialValue: _currentPage.toString(),
                                keyboardType: TextInputType.number,
                                onSaved: (value) =>
                                _currentPage = int.tryParse(value ?? '0') ?? 0,
                                validator: (value) {
                                  final v = int.tryParse(value ?? '');
                                  if (v == null || v < 0) return 'Invalid'; // Сократил сообщение
                                  if (_totalPages > 0 && v > _totalPages) return 'Too high';
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 150, // Можно сделать гибче через Expanded
                            height: 75,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(38.0), // Сделал радиус чуть меньше для эстетики
                              ),
                            ),
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Total',
                                ),
                                initialValue: _totalPages.toString(),
                                keyboardType: TextInputType.number,
                                onSaved: (value) =>
                                _totalPages = int.tryParse(value ?? '0') ?? 0,
                                validator: (value) {
                                  final v = int.tryParse(value ?? '');
                                  if (v == null || v < 0) return 'Invalid'; // Ноль страниц тоже невалиден, если книга есть
                                  // if (v == 0 && _currentPage > 0) return 'Invalid'; // Если текущая > 0, а всего 0
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveBook,
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}