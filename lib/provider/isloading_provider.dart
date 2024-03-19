import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IsLoadingProvider extends ChangeNotifier {
  late bool _isLoading;

  IsLoadingProvider() {
    _isLoading = false;
  }

  bool get isLoading => _isLoading;

  void setLoading(bool newLoading) {
    _isLoading = newLoading;
    notifyListeners();
  }
}