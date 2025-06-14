class Calculator {
  double calcProgress(int? currentPage, int? totalPages) {
    if (currentPage == null || totalPages == null || totalPages == 0) {
      return 0.0;
    } else {
      return (currentPage / totalPages) * 100;
    }
  }
}