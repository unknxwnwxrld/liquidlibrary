import 'package:flutter/material.dart';
import 'package:liquidlibrary/ui/book_overview_page.dart';
import 'package:liquidlibrary/widgets/book_cover.dart';


class LibraryBookCard extends StatelessWidget {
  final String title;
  final String? author;
  final String? coverPath;

  const LibraryBookCard({
    super.key,
    required this.title,
    this.author,
    this.coverPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell (
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => BookOverviewPage(title: title)),
        // );
      },
      child: Padding (
        padding: EdgeInsets.all(16.0),
        child: Row (
          children: [
            BookCover (
              coverPath: coverPath!,
              size: 'small',
            ),
            Padding (
              padding: EdgeInsets.only(left: 12.0),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text (
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (author != null)
                    Text (
                      author!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
