import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendanceLabor.dart';
import 'package:nanyang_application/model/attendanceWorker.dart';
import 'package:nanyang_application/screen/mobile/absensi_detail.dart';
import 'package:nanyang_application/service/attendance_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _attendanceService;

  AttendanceViewModel({required AttendanceService attendanceService})
      : _attendanceService = attendanceService;

  Future<List<AttendanceWorkerModel>?> getTodayWorkerAttendance(
      String date) async {
    try {
      List<AttendanceWorkerModel> attendance =
          await _attendanceService.getWorkerAttedance(date);

      return attendance;
    } catch (e) {
      print('error: $e');
      throw Exception(e);
    }
  }

  Future<List<AttendanceLaborModel>?> getTodayLaborerAttendance(
      String date) async {
    try {
      List<AttendanceLaborModel> attendance =
          await _attendanceService.getLaborerAttendance(date);

      return attendance;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AttendanceLaborModel> getLaborerAttendanceByID(int id) async {
    try {
      AttendanceLaborModel attendance =
          await _attendanceService.getLaborerAttendanceByID(id);

      return attendance;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> storeTodayLaborerAttendance(
      AttendanceLaborModel model,
      String date,
      String status,
      int type,
      int? initialQty,
      int? finalQty,
      double? initialWeight,
      double? finalWeight,
      int? cleanScore) async {
    try {
      await _attendanceService.storeLaborerAttendance(model, date, status, type,
          initialQty, finalQty, initialWeight, finalWeight, cleanScore);

      notifyListeners();
    } catch (e) {
      print('error: $e');
      throw Exception(e);
    }
  }
}
