import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme(bool value) {
    debugPrint("Called");
    _isDarkTheme = value;
    debugPrint(value.toString());
    notifyListeners();
  }
}
