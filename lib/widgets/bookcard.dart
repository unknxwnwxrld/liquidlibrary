import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String coverUrl;
  final int currentPage;
  final int totalPages;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0), // Margin around the card
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Fit to content vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(7.0),
                  child: Image.network(
                    coverUrl,
                    width: 100.0,
                    height: 134.0,
                    // Remove height to allow vertical fit
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 4.0
                      ),
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600]
                        ),
                      ),
                      SizedBox(
                        height: 20.0
                      ),
                      Row(
                        children: [
                          // Example: Progress indicator for current page
                          Expanded(
                            child: LinearProgressIndicator(
                              value: totalPages > 0 ? currentPage / totalPages : 0,
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '${totalPages > 0 ? (currentPage / totalPages * 100).toStringAsFixed(2) : '0'}%',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: (){},
                              label: Text('Resume'),
                              icon: Icon(Icons.play_arrow),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}