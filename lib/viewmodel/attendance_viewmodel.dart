import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
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
}
