import 'package:flutter/material.dart';
import 'package:liquidlibrary/ui/book_overview_page.dart';
import 'package:liquidlibrary/widgets/book_cover.dart';
import 'package:liquidlibrary/services/calculator.dart';


class LibraryBookCard extends StatelessWidget {
  final int? id;
  final String title;
  final String? author;
  final String? coverPath;
  final int? currentPage;
  final int? totalPages;
  double? progress;

  final VoidCallback onDelete;
  Calculator calculator = Calculator();

  LibraryBookCard({
    super.key,
    required this.id,
    required this.title,
    this.author,
    this.coverPath,
    required this.currentPage,
    required this.totalPages,
    this.progress,
    required this.onDelete,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => BookOverviewPage(id: id!))
        );
        if(result == true) {
          onDelete();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(
              coverPath: coverPath!,
              size: 'small',
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (author != null)
                          Text(
                            author!,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                            
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text('${(calculator.calcProgress(currentPage, totalPages)).toStringAsFixed(0)}%'),
                        ),
                        SizedBox(height: 8.0),
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: IconButton.filledTonal(
                            onPressed: () {},
                            icon: Icon(Icons.play_arrow_outlined),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
