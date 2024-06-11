import 'package:flutter/material.dart';

class ConfigurationScreenProvider with ChangeNotifier {
  late String _selectedConfigPage;
  late bool isEdit;

  String get configPage => _selectedConfigPage;

  ConfigurationPageProvider() {
    _selectedConfigPage = '';
    isEdit = false;
  }

  void setPage(String type){
    _selectedConfigPage = type;
    notifyListeners();
  }

  void setEdit(bool edit){
    isEdit = edit;
    notifyListeners();
  }
}
