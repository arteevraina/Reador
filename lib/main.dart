import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:reador/models/book.dart';
import 'package:reador/provider/theme_provider.dart';
import 'package:reador/screens/books_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(BookAdapter());
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        theme: ThemeData(
            fontFamily: "OpenSans",
            brightness:
                provider.isDarkTheme ? Brightness.dark : Brightness.light),
        title: 'Material App',
        home: const BooksList(),
      );
    });
  }
}
