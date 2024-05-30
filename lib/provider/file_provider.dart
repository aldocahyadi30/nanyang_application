import 'dart:io';
import 'package:flutter/material.dart';

class FileProvider extends ChangeNotifier {
  late File _file;
  late String _fileName;

  FileProvider() {
    _file = File('');
    _fileName = '';
  }

  File get file => _file;
  String get fileName => _fileName;

  void setFile(File newFile) {
    _file = newFile;
    _fileName = newFile.path.split('/').last;
    notifyListeners();
  }
}