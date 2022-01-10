import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:reador/provider/book_provider.dart';
import 'package:reador/screens/add_book.dart';
import 'package:reador/screens/edit_book.dart';

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
                      return Card(
                        key: ValueKey(provider.items[index].id),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                EditBook.route(
                                    bookProvider: context.read<BookProvider>(),
                                    index: index));
                          },
                          title: Text(provider.items[index].name),
                          subtitle: LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width * 0.6,
                            lineHeight: 16.0,
                            backgroundColor: Colors.grey,
                            percent: (provider.items[index].pagesRead /
                                provider.items[index].totalPages),
                            progressColor: Colors.green,
                            center: Text(
                                "${((provider.items[index].pagesRead / provider.items[index].totalPages) * 100).toInt()}%"),
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