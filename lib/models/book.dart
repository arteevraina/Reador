import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  // Unique id of the book depends on DateTime.
  @HiveField(0)
  final String id;
  // Name of the book.
  @HiveField(1)
  final String name;
  // These will be used to calculate the percentage of book read.
  // Pages read in the book.
  @HiveField(2)
  final double pagesRead;
  // Pages in the book.
  @HiveField(3)
  final double totalPages;

  Book(this.id, this.name, this.pagesRead, this.totalPages);
}
