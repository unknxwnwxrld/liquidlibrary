import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/book_cover.dart';
import 'package:liquidlibrary/models/book.dart';

class BookOverviewPage extends StatelessWidget {
  final int id;
  final String title;
  final String? author;
  final String? coverPath;

  const BookOverviewPage({
    super.key,
    required this.id,
    required this.title,
    this.author,
    this.coverPath,
  });

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                BookCover(size: 'small', coverPath: coverPath!)
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Read',
        child: Icon(Icons.play_arrow_outlined),
      ),
    );
  }
}