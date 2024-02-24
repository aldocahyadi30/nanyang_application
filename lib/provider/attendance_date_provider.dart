import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  late String _date;

  DateProvider() {
    _date = ''; // Initialize with an empty string
  }

  String get date => _date;

  void setDate(String newDate) {
    _date = newDate;
    notifyListeners();
  }
}
