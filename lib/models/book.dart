import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'book.g.dart';
part 'book.freezed.dart';

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
