import 'package:hive/hive.dart';
import 'package:reador/models/book.dart';

abstract class BookRepository {
  Future<void> addBook(Book book);

  Future<List<Book>> getAllBooks();

  Future<void> deleteBook(int index);

  Future<void> updateBook(Book book, int index);
}

class BookRepositoryAPI implements BookRepository {
  final String name = "Book";

  @override
  Future<void> addBook(Book book) async {
    var box = await Hive.openBox<Book>(name);
    await box.add(book);
  }

  @override
  Future<List<Book>> getAllBooks() async {
    final box = await Hive.openBox<Book>(name);
    return box.values.toList();
  }

  @override
  Future<void> deleteBook(int index) async {
    final box = await Hive.openBox<Book>(name);
    await box.deleteAt(index);
  }

  @override
  Future<void> updateBook(Book book, int index) async {
    final box = await Hive.openBox<Book>(name);
    await box.putAt(index, book);
  }
}
