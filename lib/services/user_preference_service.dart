import 'package:flutter/material.dart';
import '../theme/app_themes.dart';

class UserPreference extends ChangeNotifier {
  ThemeData theme = AppThemes.darkTheme;

  void setTheme() {
    final isDark = theme.brightness == Brightness.dark;
    theme = isDark ? AppThemes.lightTheme : AppThemes.darkTheme;
    notifyListeners();
  }
}
