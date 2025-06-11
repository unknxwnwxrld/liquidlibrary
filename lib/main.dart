import 'package:flutter/material.dart';
import 'package:liquidlibrary/ui/app_home.dart';
import 'package:liquidlibrary/services/themes.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Инициализируем FFI
    databaseFactory = databaseFactoryFfi; // Устанавливаем factory для sqflite
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.getLightTheme(),
      darkTheme: Themes.getDarkTheme(),
      themeMode: ThemeMode.system,
      home: AppHome(),
    )
  );
}

