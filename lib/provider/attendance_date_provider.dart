import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  late String _date;

  DateProvider() {
    _date = DateTime.now().toString().substring(0, 10);
  }

  String get date => _date;

  void setDate(String newDate) {
    _date = newDate;
    notifyListeners();
  }
}
