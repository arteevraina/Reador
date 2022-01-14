import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reador/models/book.dart';
import 'package:reador/provider/book_provider.dart';
import 'package:reador/provider/theme_provider.dart';
import 'package:reador/screens/add_book.dart';
import 'package:reador/screens/edit_book.dart';
import 'package:reador/screens/favorite_book_list.dart';

class BooksList extends StatelessWidget {
  const BooksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Call it at the start when instance of BookProvider is created.
      create: (context) => BookProvider()..getAllBooks(),
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
                  if (provider.items.isEmpty) {
                    return const Center(
                      child: Text("Please add books in your reading list"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      int percent = ((provider.items[index].pagesRead /
                                  provider.items[index].totalPages) *
                              100)
                          .toInt();
                      return Card(
                        key: ValueKey(provider.items[index].id),
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
                                  isFavorite: provider.items[index].favorite,
                                  dateTime: provider.items[index].id,
                                ),
                              );
                            },
                            title: Text(provider.items[index].name),
                            subtitle: PercentIndicator(percent: percent),
                            leading: IconButton(
                              icon: (provider.items[index].favorite)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite),
                              onPressed: () {
                                context.read<BookProvider>().updateBook(
                                      Book(
                                        provider.items[index].id,
                                        provider.items[index].name,
                                        provider.items[index].pagesRead,
                                        provider.items[index].totalPages,
                                        !provider.items[index].favorite,
                                      ),
                                      index,
                                    );
                              },
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                context.read<BookProvider>().delete(index);
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
                    itemCount: provider.items.length,
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
