

import 'package:flutter/cupertino.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/employee_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeViewModel extends ChangeNotifier {
  final EmployeeService _employeeService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  int workerCount = 0;
  int laborCount = 0;
  List<EmployeeModel> employee = [];

  EmployeeViewModel({required EmployeeService employeeService}) : _employeeService = employeeService;

  Future<void> getEmployee() async{
    try {
      List<Map<String, dynamic>> data = await _employeeService.getEmployee();

      employee = EmployeeModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Employee error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getCount() async{
    try{
      List<int> countData = await _employeeService.getEmployeeCount();

      workerCount = countData[0];
      laborCount = countData[1];
      notifyListeners();
    }catch(e){
      if (e is PostgrestException) {
        debugPrint('Employee error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Employee error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  String getShortenedName(String name) {
    List<String> nameParts = name.split(' ');

    if (nameParts.length == 1) {
      return nameParts[0];
    } else if (nameParts.length == 2) {
      return nameParts.join(' ');
    } else {
      return nameParts.take(2).join(' ') + nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
    }
  }

  String getAvatarInitials(String name) {
    List<String> nameParts = name.split(' ');

    return ((nameParts.isNotEmpty ? nameParts[0][0] : '') + (nameParts.length > 1 ? nameParts[1][0] : ''))
        .toUpperCase();
  }
}