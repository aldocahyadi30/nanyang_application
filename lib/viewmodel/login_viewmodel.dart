import 'package:flutter/material.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  LoginViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<UserModel?> login(String email, String password) async {
    try {
      UserModel user = await _authenticationService.login(email, password);
      return user;
    } catch (e) {
      // Handle error
      return null;
    }
  }
}