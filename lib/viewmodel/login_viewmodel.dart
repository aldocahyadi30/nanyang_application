import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  LoginViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<UserModel?> login(String email, String password) async {
    try {
      UserModel user = await _authenticationService.login(email, password);
      return user;
    } catch (e) {
      if (e is AuthException) {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false)
            .showToast('Akun tidak ditemukan!', 'error');
      } else if (e is PostgrestException) {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false)
            .showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false)
            .showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }
}
