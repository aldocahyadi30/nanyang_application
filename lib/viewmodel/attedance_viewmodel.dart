import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attedance_worker.dart';
import 'package:nanyang_application/service/attendance_service.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _attendanceService;

  AttendanceViewModel({required AttendanceService attendanceService})
      : _attendanceService = attendanceService;

  Future<List<AttedanceWorkerModel>?> getTodayWorkerAttendance(
      String date) async {
    try {
      List<AttedanceWorkerModel> attendance =
          await _attendanceService.getWorkerAttedance(date);

      return attendance;
    } catch (e) {
      throw Exception(e);
    }
  }
}
