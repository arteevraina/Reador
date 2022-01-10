import 'package:hive/hive.dart';
import 'package:reador/models/book.dart';

class BookRepository {
  final String name = "Book";

  void addBook(Book book) async {
    var box = await Hive.openBox<Book>(name);
    box.add(book);
  }

  Future<List<Book>> getAllBooks() async {
    final box = await Hive.openBox<Book>(name);
    return box.values.toList();
  }

  Future<void> deleteBook(int index) async {
    final box = await Hive.openBox<Book>(name);
    box.deleteAt(index);
  }

  void updateBook(Book book, int index) async {
    final box = await Hive.openBox<Book>(name);
    box.putAt(index, book);
  }
}
