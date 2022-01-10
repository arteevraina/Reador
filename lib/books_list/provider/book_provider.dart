import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reador/models/book.dart';

class BookProvider extends ChangeNotifier {
  // List of books in the cart. This is kept private.
  final List<Book> _books = [];

  /// An unmodifiable view of the books in the display.
  UnmodifiableListView<Book> get items => UnmodifiableListView(_books);

  /// Adds book [Book] into the list of books.
  void add(Book book) {
    _books.add(book);

    // This call tells the widgets listening to this widget to rebuild.
    notifyListeners();
  }

  /// This function removes a particular book from the list of books.
  void remove(String id) {
    _books.removeWhere((element) => element.id == id);

    // This call tells the widgets listening to this widget to rebuild.
    notifyListeners();
  }
}
