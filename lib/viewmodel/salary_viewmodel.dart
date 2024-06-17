import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/salary.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_detail_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_form_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/service/salary_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalaryViewModel extends ChangeNotifier {
  final SalaryService _salaryService;
  final NavigationService _navigationService = Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  SalaryModel _selectedSalary = SalaryModel.empty();
  List<EmployeeModel> _employeeList = [];
  EmployeeModel _selectedEmployee = EmployeeModel.empty();
  DateTime _selectedDate = DateTime.now();

  SalaryModel get salary => _selectedSalary;
  DateTime get selectedDate => _selectedDate;
  EmployeeModel get employee => _selectedEmployee;
  List<EmployeeModel> get employeeList => _employeeList;

  SalaryViewModel({required SalaryService salaryService}) : _salaryService = salaryService;

  void setEmployee(EmployeeModel employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSalary(SalaryModel salary) {
    _selectedSalary = salary;
    notifyListeners();
  }

  Future<void> getSalary() async {
    try {
      int employeeID = _selectedEmployee.id;
      DateTime date = selectedDate;
      String period = date.year.toString() + date.month.toString().padLeft(2, '0');
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

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Salary error: ${e.message}');
      } else {
        debugPrint('Get Salary error: ${e.toString()}');
      }
      
    }
  }

  Future<void> getEmployee() async {
    try {
      List<Map<String, dynamic>> data = await _salaryService.getEmployeeList(DateFormat('yyyyMM').format(DateTime.now()));

      _employeeList = EmployeeModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Employee Salary error: ${e.message}');
      } else {
        debugPrint('Get Employee Salary error: ${e.toString()}');
      }
    }
  }

  Future<void> store() async {
    try {
      await _salaryService.store(_selectedEmployee, _selectedSalary);

      notifyListeners();
      _navigationService.navigateToReplace(const SalaryAdminScreen());
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Salary error: ${e.message}');
      } else {
        debugPrint('Store Salary error: ${e.toString()}');
      }
    }
  }

  Future<void> update() async {
    try {
      await _salaryService.update(_selectedEmployee, _selectedSalary);

      notifyListeners();
      _navigationService.navigateToReplace(const SalaryAdminScreen());
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Salary error: ${e.message}');
      } else {
        debugPrint('Update Salary error: ${e.toString()}');
      }
    }
  }

  void index() {
    getEmployee();
    _navigationService.navigateTo(const SalaryAdminScreen());
  }

  Future<void> create(EmployeeModel employee) async {
    _selectedEmployee = employee;
    _selectedDate = DateTime.now();
    notifyListeners();
    await getSalary();
    _navigationService.navigateTo(const SalaryAdminFormScreen());
  }

  Future<void> edit(EmployeeModel employee, SalaryModel salary) async {
    _selectedEmployee = employee;
    _selectedDate = DateTime.now();
    notifyListeners();
    await getSalary();
    _navigationService.navigateTo(const SalaryAdminFormScreen());
  }

  Future<void> detail(EmployeeModel employee) async {
    _selectedEmployee = employee;
    _selectedDate = DateTime.now();
    notifyListeners();
    await getSalary();
    _navigationService.navigateTo(const SalaryAdminDetailScreen());
  }
}
