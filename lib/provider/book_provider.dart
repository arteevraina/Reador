import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reador/models/book.dart';
import 'package:reador/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final _bookRepository = BookRepository();

  // List of books in the cart. This is kept private.
  final List<Book> _books = [];

  /// An unmodifiable view of the books in the display.
  UnmodifiableListView<Book> get items => UnmodifiableListView(_books);

  /// Adds book [Book] into the list of books.
  void add(Book book) async {
    // Add book in the database.
    _bookRepository.addBook(book);

    // Get all the books.
    getAllBooks();
  }

  /// This function will help in deleting the book from the list view.
  void delete(int index) {
    // Remove the book at index [index] from the database.
    _bookRepository.deleteBook(index);

    // Get all the books.
    getAllBooks();
  }

  /// This function will get all the books.
  void getAllBooks() async {
    // Get all the books from the database.
    List<Book> books = await _bookRepository.getAllBooks();
    // Clear existing _books array.
    _books.clear();
    // Populate the _books array with books from database.
    _books.addAll(books);
    // This call will tell the widgets that are listening to rebuild.
    notifyListeners();
  }

  /// This function will update a book at particular index.
  void updateBook(Book book, int index) {
    // Update the book in the database.
    _bookRepository.updateBook(book, index);

    // Get all the Books.
    getAllBooks();
  }
}
