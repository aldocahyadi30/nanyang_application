import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/salary.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_detail_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_form_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_user_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/service/salary_service.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalaryViewModel extends ChangeNotifier {
  final SalaryService _salaryService;
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final AuthViewModel _auth = Provider.of<AuthViewModel>(navigatorKey.currentContext!, listen: false);
  SalaryModel _selectedSalary = SalaryModel.empty();
  List<EmployeeModel> _employeeList = [];
  EmployeeModel _selectedEmployee = EmployeeModel.empty();
  DateTime _selectedDate = DateTime.now();

  SalaryModel get salary => _selectedSalary;

  DateTime get selectedDate => _selectedDate;

  EmployeeModel get employee => _selectedEmployee;

  List<EmployeeModel> get employeeList => _employeeList;

  SalaryViewModel({required SalaryService salaryService}) : _salaryService = salaryService;

  set selectedEmployee(EmployeeModel employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  set selectedSalary(SalaryModel salary) {
    _selectedSalary = salary;
    notifyListeners();
  }

  Future<void> getSalary() async {
    try {
      DateTime date = selectedDate;
      String period = date.year.toString() + date.month.toString().padLeft(2, '0');

      if (_auth.user.level == 1) {
        Map<String, dynamic> data = await _salaryService.getEmployeeSalary(_auth.user.employee.id, period);

        if (data.isEmpty) {
          _selectedSalary = SalaryModel.empty();
        } else {
          _selectedSalary = SalaryModel.fromMap(data);
        }
      } else {
        int employeeID = _selectedEmployee.id;
        Map<String, dynamic> data1 = await _salaryService.getEmployeeSalary(employeeID, period);

        if (data1.isEmpty) {
          String startDate = DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month - 1, 1));
          String endDate = DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, 1));
          List<dynamic> data2;
          if (_selectedEmployee.position.type == 1) {
            data2 = await _salaryService.getWorkerSalary(employeeID, startDate, endDate);
          } else {
            data2 = await _salaryService.getLaborSalary(employeeID, startDate, endDate);
          }
          _selectedSalary = SalaryModel.fromFunction(data2, period, employeeID);
        } else {
          _selectedSalary = SalaryModel.fromMap(data1);
        }
      }

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Salary error: ${e.message}');
      } else {
        debugPrint('Get Salary error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getEmployee() async {
    try {
      List<Map<String, dynamic>> data = await _salaryService.getEmployeeList(DateFormat('yyyyMM').format(selectedDate));

      _employeeList = EmployeeModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Employee Salary error: ${e.message}');
      } else {
        debugPrint('Get Employee Salary error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> store(SalaryModel model) async {
    try {
      await _salaryService.store(_selectedEmployee, model);

      notifyListeners();
      _toastProvider.showToast('Data gaji berhasil disimpan', 'success');
      _navigationService.goBack();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Salary error: ${e.message}');
      } else {
        debugPrint('Store Salary error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> update(SalaryModel model) async {
    try {
      await _salaryService.update(_selectedEmployee, model);

      notifyListeners();
      _toastProvider.showToast('Data gaji berhasil diubah', 'success');
      _navigationService.navigateToReplace(const SalaryAdminScreen());
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Salary error: ${e.message}');
      } else {
        debugPrint('Update Salary error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> index() async {
    selectedDate = DateTime.now();
    if (_auth.user.level == 1) {
      await getSalary();
      _navigationService.navigateTo(const SalaryUserScreen());
    } else {
      await getEmployee();
      _navigationService.navigateTo(const SalaryAdminScreen());
    }
  }

  Future<void> create(EmployeeModel employee) async {
    _selectedEmployee = employee;
    notifyListeners();
    await getSalary();
    _navigationService.navigateTo(const SalaryAdminFormScreen());
  }

  Future<void> edit(EmployeeModel employee, SalaryModel salary) async {
    _selectedEmployee = employee;
    notifyListeners();
    await getSalary();
    _navigationService.navigateTo(const SalaryAdminFormScreen());
  }

  Future<void> detail(EmployeeModel employee) async {
    _selectedEmployee = employee;
    notifyListeners();
    await getSalary();
    _navigationService.navigateTo(const SalaryAdminDetailScreen());
  }
}