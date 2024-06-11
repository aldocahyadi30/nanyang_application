import 'package:flutter/material.dart';
import 'package:nanyang_application/model/configuration.dart';
import 'package:nanyang_application/model/user.dart';

class ConfigurationProvider with ChangeNotifier {
  late UserModel _user;
  late ConfigurationModel _configuration;
  late String _avatarInitials;
  late String _shortenedName;
  late bool _isAdmin;

  UserModel get user => _user;
  ConfigurationModel get configuration => _configuration;
  String get shortenedName => _shortenedName;
  String get avatarInitials => _avatarInitials;
  bool get isAdmin => _isAdmin;

  void setUser(UserModel user) {
    _user = user;
    setShortenedName(user.employee.name);
    setAvatarInitials(user.employee.name);
    setIsAdmin(user.level != 1);
    notifyListeners();
  }

  void setConfiguration(ConfigurationModel configuration) {
    _configuration = configuration;
    notifyListeners();
  }

  void setShortenedName(String name) {
    List<String> nameParts = name.split(' ');

    if (nameParts.length == 1) {
      _shortenedName = nameParts[0];
    } else if (nameParts.length == 2) {
      _shortenedName = nameParts.join(' ');
    } else {
      _shortenedName = nameParts.take(2).join(' ') +
          nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
    }
  }

  void setAvatarInitials(String name) {
    List<String> nameParts = name.split(' ');

    _avatarInitials = ((nameParts.isNotEmpty ? nameParts[0][0] : '') +
        (nameParts.length > 1 ? nameParts[1][0] : ''))
        .toUpperCase();
  }

  void setIsAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
  }
}