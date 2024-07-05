import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:nanyang_application/model/attendance_user.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_admin_detail_screen.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_user_scan_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/attendance_service.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _attendanceService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final AuthViewModel _auth = Provider.of<AuthViewModel>(navigatorKey.currentContext!, listen: false);
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  int workerCount = 0;
  int laborCount = 0;
  List<AttendanceAdminModel> adminAttendance = [];
  List<AttendanceUserModel> userAttendance = [];
  AttendanceAdminModel _selectedAtt = AttendanceAdminModel.empty();
  DateTime _selectedDateAttAdmin = DateTime.now();
  DateTimeRange _selectedDateUser = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      end: DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)));

  AttendanceViewModel({required AttendanceService attendanceService}) : _attendanceService = attendanceService;

  get attendanceUser => userAttendance;

  get attendanceAdmin => adminAttendance;

  AttendanceAdminModel get selectedAtt => _selectedAtt;

  DateTime get selectedAdminDate => _selectedDateAttAdmin;

  DateTimeRange get selectedUserDate => _selectedDateUser;

  void setAttendanceAdmin(AttendanceAdminModel model) {
    _selectedAtt = model;
    notifyListeners();
  }

  set selectedAtt(AttendanceAdminModel model) {
    _selectedAtt = model;
    notifyListeners();
  }

  set selectedAdminDate(DateTime date) {
    _selectedDateAttAdmin = date;
    notifyListeners();
  }

  set selectedUserDate(DateTimeRange date) {
    _selectedDateUser = date;
    notifyListeners();
  }

  Future<void> getAdminAttendance() async {
    try {
      List<Map<String, dynamic>> data =
          await _attendanceService.getAdminAttendanceByDate(parseDateToString(_selectedDateAttAdmin));
      adminAttendance = AttendanceAdminModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Get Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getUserAttendance() async {
    try {
      String startDate = parseDateToString(_selectedDateUser.start);
      String endDate = parseDateToString(_selectedDateUser.end);
      int employeeID = _auth.user.employee.id;
      List<Map<String, dynamic>> data = await _attendanceService.getUserAttendance(employeeID, startDate, endDate);

      List<DateTime> dateRange = generateDateRange(_selectedDateUser.start, _selectedDateUser.end);

      userAttendance = AttendanceUserModel.fromSupabaseList(data, dateRange);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  List<DateTime> generateDateRange(DateTime startDate, DateTime endDate) {
    List<DateTime> dateRange = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (currentDate.weekday != DateTime.sunday) {
        dateRange.add(currentDate);
      }
    }
    return dateRange;
  }

  Future<void> getCount() async {
    try {
      List<int> data = await _attendanceService.getAttendanceCount();

      workerCount = data[0];
      laborCount = data[1];
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> storeWorker(AttendanceAdminModel model) async {
    try {
      await _attendanceService.storeWorkerAttendance(model);

      _toastProvider.showToast('Berhasil menyimpan data!', 'success');
      await getAdminAttendance();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Attendance Worker error: ${e.message}');
      } else {
        debugPrint('Store Attendance Worker error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> storeLabor(AttendanceAdminModel model) async {
    try {
      if (model.laborDetail!.status == 1) {
        double minimunWeightLoss = model.laborDetail!.initialWeight! * (model.laborDetail!.minDepreciation! / 100);
        double weightLoss = model.laborDetail!.initialWeight! - model.laborDetail!.finalWeight!;
        if (weightLoss < minimunWeightLoss) weightLoss = minimunWeightLoss;
        double normalizedLoss = weightLoss / (model.laborDetail!.initialWeight! - minimunWeightLoss);
        double score = 100 - (normalizedLoss * 100);
        model.laborDetail!.performanceScore = score;
      }
      DateTime now = DateTime(_selectedDateAttAdmin.year, _selectedDateAttAdmin.month, _selectedDateAttAdmin.day,
          DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
      model.attendance = AttendanceModel(id: 0, checkIn: now);
      await _attendanceService.storeLaborAttendance(model);

      _toastProvider.showToast('Berhasil menyimpan data!', 'success');
      await getAdminAttendance();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Attendance Labor error: ${e.message}');
      } else {
        debugPrint('Store Attendance Labor error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  void scan() {
    _navigationService.navigateTo(const AttendanceUserScanScreen());
  }

  Future<void> index() async {
    if (_auth.user.level == 1) {
      _selectedDateUser = DateTimeRange(
          start: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
          end: DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)));
      await getUserAttendance();
    } else {
      _selectedDateAttAdmin = DateTime.now();
      await getAdminAttendance();
    }
  }

  void detail(AttendanceAdminModel model) {
    _selectedAtt = model;
    _navigationService.navigateTo(const AttendanceAdminDetailScreen());
  }
}