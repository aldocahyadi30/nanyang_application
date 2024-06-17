import 'package:flutter/cupertino.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/management/screen/management_employee_detail_screen.dart';
import 'package:nanyang_application/module/management/screen/management_employee_form_screen.dart';
import 'package:nanyang_application/module/management/screen/management_employee_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/employee_service.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeViewModel extends ChangeNotifier {
  final EmployeeService _employeeService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final NavigationService _navigationService = Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  int workerCount = 0;
  int laborCount = 0;
  List<EmployeeModel> employee = [];
  EmployeeModel _selectedEmployee = EmployeeModel.empty();

  EmployeeViewModel({required EmployeeService employeeService}) : _employeeService = employeeService;

  EmployeeModel get selectedEmployee => _selectedEmployee;

  void setEmployee(EmployeeModel employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  Future<void> getEmployee() async {
    try {
      List<Map<String, dynamic>> data = await _employeeService.getEmployee();

      employee = EmployeeModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Get error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Employee Get error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getCount() async {
    try {
      List<int> countData = await _employeeService.getEmployeeCount();

      workerCount = countData[0];
      laborCount = countData[1];
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Count error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Employee Count error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  void create() {
    setEmployee(EmployeeModel.empty());
    _navigationService.navigateTo(const ManagementEmployeeFormScreen(type: 'create'));
  }

  Future<void> store(EmployeeModel model) async {
    try {
      await _employeeService.store(model);
      _toastProvider.showToast('Data karyawan berhasil ditambahkan', 'success');
      getEmployee();
      _navigationService.goBack();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Store error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Employee Store error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      getEmployee();
      _navigationService.goBack();
    }
  }

  Future<void> update(EmployeeModel model) async {
    try {
      await _employeeService.update(model);
      _toastProvider.showToast('Data karyawan berhasil diperbarui', 'success');
      getEmployee();
      _navigationService.pushAndRemoveUntil(const ManagementEmployeeScreen());
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Employee Update error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Employee Update error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      getEmployee();
      _navigationService.pushAndRemoveUntil((const ManagementEmployeeScreen()));
    }
  }

  void detail(EmployeeModel model) {
    setEmployee(model);
    _navigationService.navigateTo(const ManagementEmployeeDetailScreen());
  }

  void edit(EmployeeModel model) {
    setEmployee(model);
    _navigationService.navigateTo(const ManagementEmployeeFormScreen(
      type: 'edit',
    ));
  }
}
