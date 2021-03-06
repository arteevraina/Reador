import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reador/models/book.dart';
import 'package:reador/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _bookRepository;

  // Pass BookRepository in the constructor of BookProvider.
  BookProvider(this._bookRepository);

  // List of books in the cart. This is kept private.
  final List<Book> _books = [];

  // List of books which are favorite. This is also kept private.
  final List<Book> _favoriteBooks = [];

  /// An unmodifiable view of the books in the display.
  UnmodifiableListView<Book> get books => UnmodifiableListView(_books);

  /// An unmodifiable view of the favorite books in the display.
  UnmodifiableListView<Book> get favoriteBooks =>
      UnmodifiableListView(_favoriteBooks);

  /// Adds book [Book] into the list of books.
  Future<void> add(Book book) async {
    // Add book in the database.
    await _bookRepository.addBook(book);

    // Get all the books.
    await getAllBooks();
  }

  /// This function will help in deleting the book from the list view.
  Future<void> delete(int index) async {
    // Remove the book at index [index] from the database.
    await _bookRepository.deleteBook(index);

    // Get all the books.
    await getAllBooks();
  }

  /// This function will get all the books.
  Future<void> getAllBooks() async {
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
  Future<void> updateBook(Book book, int index) async {
    // Update the book in the database.
    await _bookRepository.updateBook(book, index);

    // Get all the Books.
    await getAllBooks();
  }

  /// This function will filter out the favorite books.
  void filterFavoriteBooks() {
    _favoriteBooks.clear();
    for (var book in _books) {
      if (book.favorite) {
        _favoriteBooks.add(book);
      }
    }
  }
}
