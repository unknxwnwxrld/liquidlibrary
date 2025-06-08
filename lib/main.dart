import 'package:flutter/material.dart';
import 'ui/main_page.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show databaseFactoryFfi, sqfliteFfiInit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    // Инициализация FFI для sqflite на Windows и Linux
    sqfliteFfiInit();
    // Устанавливаем фабрику базы данных для использования FFI
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MainPage());
}
