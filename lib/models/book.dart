class Book {
  // Unique id of the book depends on DateTime.
  final String id;
  // Name of the book.
  final String name;
  // These will be used to calculate the percentage of book read.
  // Pages read in the book.
  final double pagesRead;
  // Pages in the book.
  final double totalPages;

  const Book(this.id, this.name, this.pagesRead, this.totalPages);
}
