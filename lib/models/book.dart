import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'book.g.dart';
part 'book.freezed.dart';

// @HiveType(typeId: 0)
// class Book extends HiveObject {
//   // Unique id of the book depends on DateTime.
//   @HiveField(0)
//   final String id;
//   // Name of the book.
//   @HiveField(1)
//   final String name;
//   // These will be used to calculate the percentage of book read.
//   // Pages read in the book.
//   @HiveField(2)
//   final double pagesRead;
//   // Pages in the book.
//   @HiveField(3)
//   final double totalPages;
//   // Whether this book is favourite or not.
//   @HiveField(4)
//   final bool favorite;

//   Book(
//     this.id,
//     this.name,
//     this.pagesRead,
//     this.totalPages,
//     this.favorite,
//   );
// }
@freezed
class Book with _$Book {
  const Book._();
  @HiveType(typeId: 0, adapterName: 'BookAdapter')
  const factory Book({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double pagesRead,
    @HiveField(3) required double totalPages,
    @HiveField(4) required bool favorite,
  }) = _Book;
}
