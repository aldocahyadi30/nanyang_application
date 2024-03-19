import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColorProvider extends ChangeNotifier {
  late String _hexColor;
  late Color _color;

  ColorProvider() {
    _hexColor = '0xFF000000';
    _color = Color(int.parse(_hexColor));
  }

  String get hexColor => _hexColor;
  Color get color => _color;

  void setColor(Color color) {
    _color = color;
    _hexColor = color.value.toRadixString(16).substring(2).toUpperCase();
    notifyListeners();
  }
}