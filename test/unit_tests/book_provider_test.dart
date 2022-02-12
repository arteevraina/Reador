import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reador/models/book.dart';
import 'package:reador/provider/book_provider.dart';
import 'package:reador/repositories/book_repository.dart';

/// Mock [BookRepository] using [Mocktail].
class MockBookRepository extends Mock implements BookRepository {}

void main() {
  late BookProvider sut;
  late MockBookRepository mockBookRepository;

  setUp(() {
    mockBookRepository = MockBookRepository();
    sut = BookProvider(mockBookRepository);
  });

  group("BookProvider unit tests", () {
    final booksFromRepository = [
      const Book(
          id: "1",
          name: "Book 1",
          pagesRead: 100,
          totalPages: 300,
          favorite: false),
      const Book(
          id: "2",
          name: "Book 2",
          pagesRead: 100,
          totalPages: 300,
          favorite: false),
      const Book(
          id: "3",
          name: "Book 3",
          pagesRead: 100,
          totalPages: 300,
          favorite: false),
      const Book(
          id: "4",
          name: "Book 4",
          pagesRead: 100,
          totalPages: 300,
          favorite: true),
    ];

    /// Mock function for repository level [getAllBooks] function.
    void arrangeGetAllBooks() {
      when(() => mockBookRepository.getAllBooks())
          .thenAnswer((_) async => booksFromRepository);
    }

    /// Mock function for repository level [addBook] function.
    void arrangeAddBook(Book book) {
      when(() => mockBookRepository.addBook(book)).thenAnswer((_) async {
        booksFromRepository.add(book);
      });
    }

    /// Mock function for repository level [deleteBook] function.
    void arrangeDeleteBook(int index) {
      when(() => mockBookRepository.deleteBook(index)).thenAnswer((_) async {
        booksFromRepository.removeAt(index);
      });
    }

    /// Mock function for repository level [updateBook] function.
    void arrangeUpdateBook(Book book, int index) {
      when(() => mockBookRepository.updateBook(book, index))
          .thenAnswer((_) async {
        booksFromRepository.replaceRange(index, index, [book]);
      });
    }

    test(
      "Test the initial values are correct",
      () {
        /// [favoriteBooks] is empty initially.
        expect(sut.favoriteBooks, []);

        /// [books] is empty initially.
        expect(sut.books, []);
      },
    );

    test(
      "Get all books using the BookRepository",
      () async {
        // Arrange the mock.
        arrangeGetAllBooks();

        // Act.
        sut.getAllBooks();

        // Assert.
        verify(() => mockBookRepository.getAllBooks()).called(1);
      },
    );

    test(
      "Indicates that books get populated with books",
      () async {
        // Arrange the mock.
        arrangeGetAllBooks();

        // Act.
        await sut.getAllBooks();

        // Assert.
        expect(sut.books, booksFromRepository);
      },
    );

    test(
      "Adds a book when addbook is called",
      () async {
        const book = Book(
            id: "5",
            name: "Book 5",
            totalPages: 100,
            pagesRead: 300,
            favorite: false);
        // Arrange the mock.
        arrangeGetAllBooks();
        arrangeAddBook(book);

        // Act.
        await sut.getAllBooks();

        // Length before adding a book.
        final prevLength = sut.books.length;

        // Act.
        await sut.add(book);
        await sut.getAllBooks();

        // Assert.
        /// Now length should be [prevLength + 1].
        expect(sut.books.length, prevLength + 1);
      },
    );

    test(
      "Deletes a book when delete function is called",
      () async {
        // Arrange the mocks.
        arrangeGetAllBooks();
        arrangeDeleteBook(0);

        // Act.
        await sut.getAllBooks();

        // Length before deleting a book.
        final prevlength = sut.books.length;

        // Act.
        // Delete a book.
        await sut.delete(0);

        // Act.
        await sut.getAllBooks();

        // Assert.
        /// Now length should be [prevLength - 1].
        expect(sut.books.length, prevlength - 1);
      },
    );

    test(
      "updateBook function updates book",
      () async {
        // Arrange the mocks.
        arrangeGetAllBooks();
        arrangeUpdateBook(
            const Book(
                id: "1",
                name: "Book1",
                pagesRead: 10,
                totalPages: 300,
                favorite: false),
            0);

        // Act.
        await sut.updateBook(
            const Book(
                id: "1",
                name: "Book1",
                pagesRead: 10,
                totalPages: 300,
                favorite: false),
            0);
        // Assert.
        expect(
          sut.books[0],
          const Book(
              id: "1",
              name: "Book1",
              pagesRead: 10,
              totalPages: 300,
              favorite: false),
        );
      },
    );

    test(
      "Adds books in favorite books when filterFavoriteBooks is called",
      () async {
        // Arrange the mocks.
        arrangeGetAllBooks();

        // Act.
        await sut.getAllBooks();

        // Assert.
        // Initially favorite books length should be zero.
        expect(sut.favoriteBooks, isEmpty);

        // Act.
        sut.filterFavoriteBooks();

        // Assert.
        // Now favorite books length should not be zero
        // It should not be empty now.
        expect(sut.favoriteBooks, isNotEmpty);
      },
    );
  });
}
