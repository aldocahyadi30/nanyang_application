import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:nanyang_application/model/attendance_detail.dart';
import 'package:nanyang_application/model/attendance_user.dart';
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
  List<AttendanceAdminModel> adminAttendance = [];
  List<AttendanceUserModel> userAttendance = [];
  AttendanceAdminModel _selectedAtt = AttendanceAdminModel.empty();
  DateTime _selectedDateAttAdmin = DateTime.now();

  AttendanceViewModel({required AttendanceService attendanceService}) : _attendanceService = attendanceService;

  get attendanceUser => userAttendance;
  get attendanceAdmin => adminAttendance;
  AttendanceAdminModel get selectedAtt => _selectedAtt;
  get selectedAdminDate => _selectedDateAttAdmin;

  void setAttendanceAdmin(AttendanceAdminModel model) {
    _selectedAtt = model;
    notifyListeners();
  }

  void setAdminDate(DateTime date) {
    _selectedDateAttAdmin = date;
    notifyListeners();
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
      String startDate = _dateProvider.attendanceUserDateStartString;
      String endDate = _dateProvider.attendanceUserDateEndString;
      int employeeID = _configurationProvider.user.employee.id;
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

  Future<void> storeWorker(String startTime, String endTime) async {
    try {
      DateTime checkIn = DateTime(
        _selectedDateAttAdmin.year,
        _selectedDateAttAdmin.month,
        _selectedDateAttAdmin.day,
        int.parse(startTime.split(':')[0]),
        int.parse(startTime.split(':')[1]),
      );

      DateTime checkOut = DateTime(
        _selectedDateAttAdmin.year,
        _selectedDateAttAdmin.month,
        _selectedDateAttAdmin.day,
        int.parse(endTime.split(':')[0]),
        int.parse(endTime.split(':')[1]),
      );
      final attendanceModel = AttendanceAdminModel(
          employee: _selectedAtt.employee,
          attendance: AttendanceModel(id: selectedAtt.attendance!.id, checkIn: checkIn, checkOut: checkOut),
          laborDetail: AttendanceDetailModel.empty());

      await _attendanceService.storeWorkerAttendance(attendanceModel);

      getAdminAttendance(1);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Attendance Worker error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Store Attendance Worker error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> storeLabor(
      int attendanceStatus, int featherType, int initialQty, int finalQty, double initialWeight, double finalWeight, int minDeprecation) async {
    try {
      double minimunWeightLoss = initialWeight * (minDeprecation / 100);
      double weightLoss = initialWeight - finalWeight;
      if (weightLoss < minimunWeightLoss) weightLoss = minimunWeightLoss;
      double normalizedLoss = weightLoss / (initialWeight - minimunWeightLoss);
      double score = 100 - (normalizedLoss * 100);


      final attendanceModel = AttendanceAdminModel(
          employee: _selectedAtt.employee,
          attendance: AttendanceModel(id: 0, checkIn: _selectedDateAttAdmin),
          laborDetail: AttendanceDetailModel(
            id: 0,
            status: attendanceStatus,
            featherType: featherType,
            initialQty: initialQty,
            finalQty: finalQty,
            initialWeight: initialWeight,
            finalWeight: finalWeight,
            minDepreciation: minDeprecation,
            performanceScore: score,
          ));
      await _attendanceService.storeLaborAttendance(attendanceModel);

      getAdminAttendance(2);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Store Attendance Labor error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Store Attendance Labor error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }
}
