import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reador/models/book.dart';
import 'package:reador/provider/book_provider.dart';
import 'package:reador/provider/theme_provider.dart';
import 'package:reador/repositories/book_repository.dart';
import 'package:reador/screens/add_book.dart';
import 'package:reador/screens/edit_book.dart';
import 'package:reador/screens/favorite_book_list.dart';

class BooksList extends StatelessWidget {
  const BooksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Call it at the start when instance of BookProvider is created.
      create: (context) => BookProvider(BookRepository())..getAllBooks(),
      child: const BooksListView(),
    );
  }
}

class BooksListView extends StatelessWidget {
  const BooksListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organize your Readings'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                onPressed: () {
                  context
                      .read<ThemeProvider>()
                      .toggleTheme(!context.read<ThemeProvider>().isDarkTheme);
                },
                icon: (context.read<ThemeProvider>().isDarkTheme)
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
              );
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    FavoriteBookListPage.route(
                        bookProvider: context.read<BookProvider>()));
              },
              icon: const Icon(Icons.favorite))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              AddBook.route(bookProvider: context.read<BookProvider>()));
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<BookProvider>(
                builder: (context, provider, child) {
                  if (provider.books.isEmpty) {
                    return const Center(
                      child: Text("Please add books in your reading list"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      int percent = ((provider.books[index].pagesRead /
                                  provider.books[index].totalPages) *
                              100)
                          .toInt();
                      return Card(
                        key: ValueKey(provider.books[index].id),
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: ListTile(
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                EditBook.route(
                                  bookProvider: context.read<BookProvider>(),
                                  index: index,
                                  isFavorite: provider.books[index].favorite,
                                  dateTime: provider.books[index].id,
                                ),
                              );
                            },
                            title: Text(provider.books[index].name),
                            subtitle: PercentIndicator(percent: percent),
                            leading: IconButton(
                              icon: (provider.books[index].favorite)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite),
                              onPressed: () async {
                                await context.read<BookProvider>().updateBook(
                                      Book(
                                        id: provider.books[index].id,
                                        name: provider.books[index].name,
                                        pagesRead:
                                            provider.books[index].pagesRead,
                                        totalPages:
                                            provider.books[index].totalPages,
                                        favorite:
                                            !provider.books[index].favorite,
                                      ),
                                      index,
                                    );
                              },
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                await context
                                    .read<BookProvider>()
                                    .delete(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: provider.books.length,
                  );
                },
                child: const Center(
                  child: Text("Please add books in your reading list"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PercentIndicator extends StatelessWidget {
  const PercentIndicator({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Stack(
        children: [
          Container(
            height: 16,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          Container(
            height: 16,
            width: MediaQuery.of(context).size.width * (percent / 100),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
          Center(
            child: Text(
              "$percent%",
              style: const TextStyle(fontSize: 12.0, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
