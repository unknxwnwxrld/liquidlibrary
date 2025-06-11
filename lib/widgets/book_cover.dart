import 'package:flutter/material.dart';
import 'dart:io';

class BookCover extends StatelessWidget {
  final String size;
  final String coverPath;

  const BookCover({
    super.key,
    required this.size,
    required this.coverPath,
  });

  @override
  Widget build(BuildContext context) {
    if (coverPath.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: size == 'small' ? 100 : 200,
          height: size == 'small' ? 134 : 268,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.book, size: 30, color: Colors.black54),
        )
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(coverPath),
          width: size == 'small' ? 100 : 200,
          height: size == 'small' ? 134 : 268,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}

