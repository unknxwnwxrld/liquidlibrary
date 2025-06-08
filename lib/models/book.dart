class Book {
  int? id;
  String title;
  String author;
  String coverPath;
  int currentPage;
  int totalPages;

  Book({this.id, required this.title, required this.author, required this.coverPath, required this.currentPage, required this.totalPages});

  // Преобразование из Map (для базы)
  factory Book.fromMap(Map<String, dynamic> json) => Book(
    id: json['id'],
    title: json['title'],
    author: json['author'],
    coverPath: json['coverPath'],
    currentPage: json['currentPage'] ?? 0,
    totalPages: json['totalPages'] ?? 0,
  );

  // Преобразование в Map (для базы)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverPath': coverPath,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}
