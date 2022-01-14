import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reador/provider/book_provider.dart';
import 'package:reador/screens/books_list.dart';

class FavoriteBookListPage extends StatelessWidget {
  static route({required BookProvider bookProvider}) => MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<BookProvider>.value(
          value: bookProvider..filterFavoriteBooks(),
          child: const FavoriteBookListPage(),
        ),
      );
  const FavoriteBookListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FavoriteBookListView();
  }
}

class FavoriteBookListView extends StatelessWidget {
  const FavoriteBookListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Reads'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<BookProvider>(
                builder: (context, provider, child) {
                  if (provider.favoriteBooks.isEmpty) {
                    return const Center(
                      child: Text("Please add books in your favorite list"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      int percent = ((provider.favoriteBooks[index].pagesRead /
                                  provider.favoriteBooks[index].totalPages) *
                              100)
                          .toInt();
                      return Card(
                        key: ValueKey(provider.favoriteBooks[index].id),
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(provider.favoriteBooks[index].name),
                            subtitle: PercentIndicator(percent: percent),
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: provider.favoriteBooks.length,
                  );
                },
                child: const Center(
                  child: Text("Please add books in your favorite list"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
