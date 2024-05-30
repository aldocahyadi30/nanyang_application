import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_user.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/attendance_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _attendanceService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final DateProvider _dateProvider = Provider.of<DateProvider>(navigatorKey.currentContext!, listen: false);
  final ConfigurationProvider _configurationProvider = Provider.of<ConfigurationProvider>(navigatorKey.currentContext!, listen: false);
  int workerCount = 0;
  int laborCount = 0;
  List<AttendanceWorkerModel> workerAttendance = [];
  List<AttendanceLaborModel> laborAttendance = [];
  List<AttendanceAdminModel> adminAttendance = [];
  List<AttendanceUserModel> userAttendance = [];

  AttendanceViewModel({required AttendanceService attendanceService}) : _attendanceService = attendanceService;

  get attendanceWorker => workerAttendance;
  get attendanceLabor => laborAttendance;
  get attendanceUser => userAttendance;
  get attendanceAdmin => adminAttendance;

  Future<void> getWorkerAttendance() async {
    try {
      String date = _dateProvider.attendanceWorkerDateString;
      List<Map<String, dynamic>> data = await _attendanceService.getWorkerAttendanceByDate(date);

      workerAttendance = AttendanceWorkerModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getLaborAttendance() async {
    try {
      String date = _dateProvider.attendanceLaborDateString;
      List<Map<String, dynamic>> data = await _attendanceService.getLaborAttendanceByDate(date);

      laborAttendance = AttendanceLaborModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getAdminAttendance(int type) async {
    try {
      String date = '';
      List<Map<String, dynamic>>? data;
      if (type == 1) {
        date = _dateProvider.attendanceWorkerDateString;
        data = await _attendanceService.getAdminAttendanceByDate(date, type);
      } else if (type == 2) {
        date = _dateProvider.attendanceLaborDateString;
        data = await _attendanceService.getAdminAttendanceByDate(date, type);
      }
      adminAttendance = AttendanceAdminModel.fromSupabaseList(data!);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getUserAttendance() async {
    try {
      String startDate = _dateProvider.attendanceUserDateStartString;
      String endDate = _dateProvider.attendanceUserDateEndString;
      int employeeID = _configurationProvider.user.employeeId;
      List<Map<String, dynamic>> data = await _attendanceService.getUserAttendance(employeeID, startDate, endDate);

      List<DateTime> dateRange = generateDateRange(_dateProvider.attendanceUserDateStart, _dateProvider.attendanceUserDateEnd);

      userAttendance = AttendanceUserModel.fromSupabaseList(data, dateRange);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
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
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<AttendanceLaborModel> getLaborerAttendanceByID(int id) async {
    try {
      AttendanceLaborModel attendance = await _attendanceService.getLaborAttendanceByID(id);

      return attendance;
    } catch (e) {
      throw Exception(e);
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

    return ((nameParts.isNotEmpty ? nameParts[0][0] : '') + (nameParts.length > 1 ? nameParts[1][0] : '')).toUpperCase();
  }

  Future<void> storeTodayLaborerAttendance(AttendanceLaborModel model, String date, String status, int type, int? initialQty, int? finalQty,
      double? initialWeight, double? finalWeight, int? cleanScore) async {
    try {
      await _attendanceService.storeLaborAttendance(model, date, status, type, initialQty, finalQty, initialWeight, finalWeight, cleanScore);
      _toastProvider.showToast('Absensi berhasil disimpan', 'success');

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }
}
