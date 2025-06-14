import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/book_cover.dart';
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/databases/dbprovider.dart';
import 'package:liquidlibrary/services/calculator.dart';

class BookOverviewPage extends StatelessWidget {
  final dbprovider = DBProvider.db;
  final int id;
  double? progress;

  Calculator calculator = Calculator();

  BookOverviewPage({
    super.key,
    required this.id,
    this.progress,
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
          if(book.currentPage == null || book.totalPages == null || book.totalPages == 0) {
            progress = 0;
          } else {
            progress = (book.currentPage! / book.totalPages! * 100).toDouble();
          }
          return Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookCover(size: 'small', coverPath: book.coverPath),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          Text(
                            book.author!,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 24,),
                          LinearProgressIndicator(
                            value: calculator.calcProgress(book.currentPage, book.totalPages)/100,
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text('${(calculator.calcProgress(book.currentPage, book.totalPages)).toStringAsFixed(0)}%'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    
                  ],
                ),
              ],
            )
          );
        }
      },
    );
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Edit book
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){},
          ),
          // Delete book
          IconButton(
            onPressed: () async {
              await dbprovider.deleteBook(id);
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.delete_outline)
          ),
        ],
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