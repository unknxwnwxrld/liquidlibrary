class Book {
  int? id;
  String title;
  String? author;
  String? coverPath;
  int? currentPage;
  int? totalPages;
  String? status;
  String? dateStarted;
  String? dateFinished;
  String? genres;
  int? rating;
  String? notes;
  String? cycle;
  String? filePath;

  Book({
    this.id,
    required this.title,
    this.author,
    this.coverPath,
    this.currentPage,
    this.totalPages,
    this.status,
    this.dateStarted,
    this.dateFinished,
    this.genres,
    this.rating,
    this.notes,
    this.cycle,
    this.filePath,
  });

  Map<String, dynamic>toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverPath': coverPath,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'status': status,
      'dateStarted': dateStarted,
      'dateFinished': dateFinished,
      'genres': genres,
      'rating': rating,
      'notes': notes,
      'cycle': cycle,
      'filePath': filePath,
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
      status: map['status'],
      dateStarted: map['dateStarted'],
      dateFinished: map['dateFinished'],
      genres: map['genres'],
      rating: map['rating'],
      notes: map['notes'],
      cycle: map['cycle'],
      filePath: map['filePath'],
    );
  }
}
