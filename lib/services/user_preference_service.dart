import 'package:flutter/material.dart';

class UserPreference extends ChangeNotifier {
  var theme = ThemeData.dark();

  setTheme() {
    if (theme == ThemeData.dark()) {
      theme = ThemeData.light();
    } else {
      theme = ThemeData.dark();
    }
    notifyListeners();
  }
}
