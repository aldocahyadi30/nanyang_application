import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  List<UserModel> _user = [];

  UserViewModel({required UserService userService}) : _userService = userService;

  get user => _user;

  Future<UserModel> getUserByID(String id) async {
    try {
      Map<String, dynamic> data = await _userService.getUserByID(id);

      return UserModel.fromSupabase(data);
    } catch (e) {
      UserModel user = UserModel.empty();
      if (e is PostgrestException) {
        debugPrint('User error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('User error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return user;
    }
  }

  Future<void> getUser() async {
    try {
      List<Map<String,dynamic>> data = await _userService.getUser();
      _user = UserModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('User error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('User error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

}