import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:liquidlibrary/models/book.dart'; // ваш класс модели

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "BooksDB.db");
    // await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Books (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          author TEXT,
          coverPath TEXT,
          currentPage INTEGER,
          totalPages INTEGER,
          tag TEXT
        )
      ''');
    });
  }

  // Создание записи
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('Books', book.toMap());
  }

  // Получение всех книг
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    var res = await db.query('Books');
    List<Book> list = res.isNotEmpty ? res.map((c) => Book.fromMap(c)).toList() : [];
    return list;
  }

  // Обновление книги
  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update('Books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  // Удаление книги
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete('Books', where: 'id = ?', whereArgs: [id]);
  }

  // Получение книг по тегу
  Future<List<Book>> getBooksByTag(String tag) async {
    final db = await database;
    var res = await db.query('Books', where: 'tag = ?', whereArgs: [tag]);
    return res.isNotEmpty ? res.map((c) => Book.fromMap(c)).toList() : [];
  }
}
