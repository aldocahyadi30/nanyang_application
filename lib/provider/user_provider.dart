import 'package:flutter/material.dart';
import 'package:nanyang_application/model/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  String? _avatarInitials;
  String? _shortenedName;

  UserModel? get user => _user;
  String? get shortenedName => _shortenedName;
  String? get avatarInitials => _avatarInitials;

  void setUser(UserModel user) {
    _user = user;
    setShortenedName(user.name);
    setAvatarInitials(user.name);
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
}
