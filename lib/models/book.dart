class Book {
  int? id;
  String title;
  String? author;
  String? coverPath;
  int? currentPage;
  int? totalPages;
  String? tag;
  String? dateStarted;
  String? dateFinished;
  String? genres;
  int? rating;
  String? notes;
  String? cycle;
  String? epubPath;

  Book({
    this.id,
    required this.title,
    this.author,
    this.coverPath,
    this.currentPage,
    this.totalPages,
    this.tag,
    this.dateStarted,
    this.dateFinished,
    this.genres,
    this.rating,
    this.notes,
    this.cycle,
    this.epubPath,
  });

  Map<String, dynamic>toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverPath': coverPath,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'tag': tag,
      'dateStarted': dateStarted,
      'dateFinished': dateFinished,
      'genres': genres,
      'rating': rating,
      'notes': notes,
      'cycle': cycle,
      'epubPath': epubPath,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      coverPath: map['coverPath'],
      currentPage: map['currentPage'],
      totalPages: map['totalPages'],
      tag: map['tag'],
      dateStarted: map['dateStarted'],
      dateFinished: map['dateFinished'],
      genres: map['genres'],
      rating: map['rating'],
      notes: map['notes'],
      cycle: map['cycle'],
      epubPath: map['epubPath'],
    );
  }
}
