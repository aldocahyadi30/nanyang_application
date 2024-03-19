import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);

  LoginViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<UserModel?> login(String email, String password) async {
    try {
      UserModel user = await _authenticationService.login(email, password);
      return user;
    } catch (e) {
      UserModel user = UserModel.empty();
      if (e is AuthException) {
        _toastProvider.showToast('Akun tidak ditemukan!', 'error');
      } else if (e is PostgrestException) {
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return user;
    }
  }
}