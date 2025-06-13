import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/book_cover.dart';
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/databases/dbprovider.dart';

class BookOverviewPage extends StatelessWidget {
  final dbprovider = DBProvider.db;
  final int id;

  BookOverviewPage({
    super.key,
    required this.id,
  });

  Widget _buildBookOverview() {
    return FutureBuilder<Book?>(
      future: dbprovider.getBookById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('Книга не найдена');
        } else {
          final book = snapshot.data!;
          return Column(
            children: [
              Text('Название: ${book.title}'),
              Text('Автор: ${book.author}'),
            ],
          );
        }
      },
    );
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: _buildBookOverview(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Read',
        child: Icon(Icons.play_arrow_outlined),
      ),
    );
  }
}