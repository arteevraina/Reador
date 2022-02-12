import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reador/models/book.dart';
import 'package:reador/provider/book_provider.dart';

class AddBook extends StatelessWidget {
  // Create a static method for route of Navigation.
  /// Provide the already created instance of [BookProvider]
  /// to [AddBook].
  static route({required BookProvider bookProvider}) => MaterialPageRoute(
        builder: (context) => AddBook(
          bookProvider: bookProvider,
        ),
      );
  final BookProvider bookProvider;
  const AddBook({Key? key, required this.bookProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookProvider>.value(
      value: bookProvider,
      child: const AddBookView(),
    );
  }
}

class AddBookView extends StatefulWidget {
  const AddBookView({Key? key}) : super(key: key);

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _bookNameController = TextEditingController();
  final _pagesReadController = TextEditingController();
  final _totalPagesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to Reading List"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the name of book";
                  }
                },
                controller: _bookNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Book\'s Name',
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter pages read";
                        }
                      },
                      keyboardType: TextInputType.number,
                      controller: _pagesReadController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Pages Read',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter total pages of the book";
                        }
                      },
                      keyboardType: TextInputType.number,
                      controller: _totalPagesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Total Pages',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              ElevatedButton.icon(
                onPressed: () async {
                  // If the validation works fine then proceed.
                  if (_formKey.currentState!.validate()) {
                    // Check if the pages read are always less than equal
                    // to total pages in the book.
                    if (double.parse(_pagesReadController.text) <=
                        double.parse(_totalPagesController.text)) {
                      await context.read<BookProvider>().add(Book(
                            id: DateTime.now().toString(),
                            name: _bookNameController.text,
                            pagesRead: double.parse(_pagesReadController.text),
                            totalPages:
                                double.parse(_totalPagesController.text),
                            // Initially the book is not favorite.
                            favorite: false,
                          ));

                      // If everything works, then show a snackbar that
                      // book is added.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Book Added !"),
                        duration: Duration(seconds: 2),
                      ));

                      // clear all the text form fields.
                      _bookNameController.clear();
                      _pagesReadController.clear();
                      _totalPagesController.clear();
                    } else {
                      // If the pages read are greater than the total pages in
                      // book by accident.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Pages read cannot be greater than total pages !"),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text("Add Book"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
