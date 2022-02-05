import 'package:hive/hive.dart';
import 'package:reador/models/book.dart';

class BookRepository {
  final String name = "Book";

  Future<void> addBook(Book book) async {
    var box = await Hive.openBox<Book>(name);
    await box.add(book);
  }

  Future<List<Book>> getAllBooks() async {
    final box = await Hive.openBox<Book>(name);
    return box.values.toList();
  }

  Future<void> deleteBook(int index) async {
    final box = await Hive.openBox<Book>(name);
    await box.deleteAt(index);
  }

  Future<void> updateBook(Book book, int index) async {
    final box = await Hive.openBox<Book>(name);
    await box.putAt(index, book);
  }
}
