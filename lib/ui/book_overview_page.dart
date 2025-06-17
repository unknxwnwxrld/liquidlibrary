import 'package:flutter/material.dart';
import 'package:liquidlibrary/widgets/book_cover.dart';
import 'package:liquidlibrary/models/book.dart';
import 'package:liquidlibrary/databases/dbprovider.dart';
import 'package:liquidlibrary/services/calculator.dart';
import 'package:liquidlibrary/ui/book_add_page.dart';

class BookOverviewPage extends StatefulWidget {
  final int id;
  double? progress;

  BookOverviewPage({
    super.key,
    required this.id,
    this.progress,
  });

  @override
  State<BookOverviewPage> createState() => _BookOverviewPageState();
}

class _BookOverviewPageState extends State<BookOverviewPage> {
  final dbprovider = DBProvider.db;
  Calculator calculator = Calculator();

  Future<Book?> _getBook() async {
    return await dbprovider.getBookById(widget.id);
  }

  Widget _buildBookOverview() {
    return FutureBuilder<Book?>(
      future: dbprovider.getBookById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('Книга не найдена');
        } else {
          final book = snapshot.data!;
          double progress;
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
                    Stack(
                      children: [
                        BookCover(size: 'small', coverPath: book.coverPath),
                        Positioned(
                          right: 2,
                          bottom: 4,
                          child: switch (book.status) {
                            'Reading' => Icon(Icons.radio_button_unchecked, color: Colors.deepPurpleAccent),
                            'Planned' => Icon(Icons.control_point, color: Colors.lightBlueAccent),
                            'Complete' => Icon(Icons.check_circle_outline, color: Colors.lightGreenAccent),
                            'Holded' => Icon(Icons.schedule, color: Colors.orangeAccent),
                            'Dropped' => Icon(Icons.highlight_off, color: Colors.deepOrangeAccent),
                            _ => SizedBox.shrink(),
                          }
                        ),
                      ],
                    ),
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
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Align(
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // чтобы не растягивался на всю ширину
                      children: [
                        Container(
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                            color: Theme.of(context).colorScheme.primaryContainer,
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.currentPage.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  book.dateStarted == 'null' ? 'dd.mm.yyyy' : book.dateStarted ?? 'dd.mm.yyyy',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.totalPages.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  book.dateFinished == 'null' ? 'dd.mm.yyyy' : book.dateFinished ?? 'dd.mm.yyyy',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final book = await _getBook();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookAddPage(book: book)),
              );
              if (result == true) {
                setState(() {});
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            onPressed: () async {
              await dbprovider.deleteBook(widget.id);
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