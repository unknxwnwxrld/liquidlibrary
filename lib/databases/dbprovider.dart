import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:liquidlibrary/models/book.dart';

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
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Books (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          author TEXT,
          coverPath TEXT,
          currentPage INTEGER,
          totalPages INTEGER,
          tag TEXT,
          dateStarted TEXT,
          dateFinished TEXT,
          genres TEXT,
          rating INTEGER,
          notes TEXT,
          cycle TEXT,
          epubPath TEXT
        )
      ''');
    });
  }
  // CREATE, READ, UPDATE, DELETE (CRUD) operations
  // Create
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('Books', book.toMap());
  }
  // Read all
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Books');
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }
  // Read by ID
  Future<Book?> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Books', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }
  // Update
  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update('Books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  // Delete
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete('Books', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Book>> getBooksByStatus(String status) async {
    final db = await database;
    var res = await db.query('Books', where: 'tag = ?', whereArgs: [status]);
    return res.isNotEmpty ? res.map((c) => Book.fromMap(c)).toList() : [];
  }
}