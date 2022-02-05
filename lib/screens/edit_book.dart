import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reador/models/book.dart';
import 'package:reador/provider/book_provider.dart';

class EditBook extends StatelessWidget {
  // Create a static method for route of Navigation.
  /// Provide the already created instance of [BookProvider]
  /// to [EditBook].
  static route(
          {required BookProvider bookProvider,
          required index,
          required isFavorite,
          required dateTime}) =>
      MaterialPageRoute(
        builder: (context) => EditBook(
          bookProvider: bookProvider,
          index: index,
          isFavorite: isFavorite,
          dateTime: dateTime,
        ),
      );
  final BookProvider bookProvider;
  final int index;
  final bool isFavorite;
  final String dateTime;
  const EditBook({
    Key? key,
    required this.bookProvider,
    required this.index,
    required this.isFavorite,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookProvider>.value(
      value: bookProvider,
      child: EditBookView(
        index: index,
        isFavorite: isFavorite,
        dateTime: dateTime,
      ),
    );
  }
}

class EditBookView extends StatefulWidget {
  const EditBookView(
      {Key? key,
      required this.index,
      required this.isFavorite,
      required this.dateTime})
      : super(key: key);
  final int index;
  final bool isFavorite;
  final String dateTime;

  @override
  State<EditBookView> createState() => _EditBookViewState();
}

class _EditBookViewState extends State<EditBookView> {
  final _formKey = GlobalKey<FormState>();
  final _bookNameController = TextEditingController();
  final _pagesReadController = TextEditingController();
  final _totalPagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookNameController.text =
        context.read<BookProvider>().books[widget.index].name;
    _pagesReadController.text = context
        .read<BookProvider>()
        .books[widget.index]
        .pagesRead
        .toInt()
        .toString();

    _totalPagesController.text = context
        .read<BookProvider>()
        .books[widget.index]
        .totalPages
        .toInt()
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
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
                      await context.read<BookProvider>().updateBook(
                            Book(
                              widget.dateTime,
                              _bookNameController.text,
                              double.parse(_pagesReadController.text),
                              double.parse(_totalPagesController.text),
                              widget.isFavorite,
                            ),
                            widget.index,
                          );

                      // If everything works, then show a snackbar that
                      // book is added.
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Book Updated !"),
                        duration: Duration(seconds: 2),
                      ));
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
                icon: const Icon(Icons.edit),
                label: const Text("Edit Book"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
