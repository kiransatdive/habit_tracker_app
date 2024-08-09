import 'package:flutter/material.dart';

import 'package:habittracker_app/theme/dark_mode.dart';
import 'package:habittracker_app/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initial , light mode
  ThemeData _themeData = lightMode;

  //get current theme
  ThemeData get themeData => _themeData;

  //is current theme dark mode
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
