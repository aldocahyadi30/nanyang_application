import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/attendance_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _attendanceService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);

  AttendanceViewModel({required AttendanceService attendanceService}) : _attendanceService = attendanceService;

  Future<List<AttendanceWorkerModel>?> getWorkerAttendance(String date) async {
    try {
      List<Map<String,dynamic>> data = await _attendanceService.getWorkerAttendanceByDate(date);

      return AttendanceWorkerModel.fromSupabaseList(data);
    } catch (e) {
      List<AttendanceWorkerModel> attendance = [];
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return attendance;
    }
  }

  Future<List<AttendanceLaborModel>?> getLaborAttendance(String date) async {
    try {
      List<Map<String,dynamic>> data = await _attendanceService.getLaborAttendanceByDate(date);

      return AttendanceLaborModel.fromSupabaseList(data);
    } catch (e) {
      List<AttendanceLaborModel> attendance = [];
      if (e is PostgrestException) {
        debugPrint('Attendance error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Attendance error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }

      return attendance;
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

    return ((nameParts.isNotEmpty ? nameParts[0][0] : '') + (nameParts.length > 1 ? nameParts[1][0] : ''))
        .toUpperCase();
  }

  Future<void> storeTodayLaborerAttendance(AttendanceLaborModel model, String date, String status, int type,
      int? initialQty, int? finalQty, double? initialWeight, double? finalWeight, int? cleanScore) async {
    try {
      await _attendanceService.storeLaborAttendance(
          model, date, status, type, initialQty, finalQty, initialWeight, finalWeight, cleanScore);
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