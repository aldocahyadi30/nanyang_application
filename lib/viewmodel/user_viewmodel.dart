import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/management/screen/management_user_detail_screen.dart';
import 'package:nanyang_application/module/management/screen/management_user_form_screen.dart';
import 'package:nanyang_application/module/management/screen/management_user_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/service/user_service.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  List<UserModel> _user = [];
  UserModel selectedUser = UserModel.empty();

  UserViewModel({required UserService userService}) : _userService = userService;

  get user => _user;

  UserModel get selected => selectedUser;

  set selected(UserModel user) {
    selectedUser = user;
    notifyListeners();
  }

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
      List<Map<String, dynamic>> data = await _userService.getUser();
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

  Future<void> index() async {
    await getUser();
    _navigationService.navigateTo(const ManagementUserScreen());
  }

  Future<void> create() async {
    selectedUser = UserModel.empty();
    await navigatorKey.currentContext!.read<EmployeeViewModel>().getEmployee();
    _navigationService.navigateTo(const ManagementUserFormScreen());
  }

  Future<void> edit(UserModel model) async {
    selectedUser = model;
    await navigatorKey.currentContext!.read<EmployeeViewModel>().getEmployee();
    _navigationService.navigateTo(const ManagementUserFormScreen());
  }

  void detail(UserModel model) {
    selectedUser = model;
    _navigationService.navigateTo(const ManagementUserDetailScreen());
  }
}