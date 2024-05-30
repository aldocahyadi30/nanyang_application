import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  late String _hexColor;
  late String _colorName;
  late Color _color;

  ColorProvider() {
    _hexColor = '0xFF000000';
    _color = Color(int.parse(_hexColor));
    _colorName = 'Black';
  }

  String get hexColor => _hexColor;
  Color get color => _color;
  String get colorName => _colorName;

  void setColor(Color color) {
    _color = color;
    _hexColor = color.value.toRadixString(16).substring(2).toUpperCase();
    _colorName = ColorTools.nameThatColor(color);
    notifyListeners();
  }
}