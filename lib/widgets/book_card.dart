import 'dart:io';
import 'package:flutter/material.dart';
import 'package:liquidlibrary/ui/instance_edit_page.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String coverPath;
  final int currentPage;
  final int totalPages;
  final int? bookId;
  final VoidCallback? onChanged;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.coverPath,
    required this.currentPage,
    required this.totalPages,
    this.bookId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalPages > 0 ? currentPage / totalPages : 0.0;
    final percent = totalPages > 0 ? ((progress * 100).round()).toString() : '0';

    Widget coverWidget;
    if (coverPath.isEmpty || !(File(coverPath).existsSync())) {
      coverWidget = Image.asset(
        'assets/images/book_cover_placeholder.png',
        width: 100.0,
        height: 134.0,
        fit: BoxFit.cover,
      );
    } else {
      coverWidget = Image.file(
        File(coverPath),
        width: 100.0,
        height: 134.0,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: 167.0,
      width: double.infinity,
      child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InstanceEditPage(bookId: bookId),
              ),
            );
            if (result == true && onChanged != null) {
              onChanged!();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7.0),
                  child: coverWidget,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            '$percent%',
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      Expanded(
                        child: Padding (
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$currentPage / $totalPages',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

// Usage
