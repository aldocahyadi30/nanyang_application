import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:nanyang_application/model/attendanceLabor.dart';
import 'package:nanyang_application/model/attendanceWorker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<AttendanceWorkerModel>> getWorkerAttedance(String date) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final attendance = await Supabase.instance.client
          .from('Employee')
          .select('''
          *,
          Position!inner(*),
          Attendance!left(*)
          ''')
          .eq('Position.type', 1)
          .gte('Attendance.date', startTime)
          .lte('Attendance.date', endTime)
          .order('name', ascending: true);
      return AttendanceWorkerModel.fromSupabaseList(attendance);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<AttendanceLaborModel>> getLaborerAttendance(String date) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final attendance = await Supabase.instance.client
          .from('Employee')
          .select('''
          *,
          Position!inner(*),
          Attendance!left(*, AttendanceDetail(*))
          ''')
          .eq('Position.type', 2)
          .gte('Attendance.date', startTime)
          .lte('Attendance.date', endTime)
          .order('name', ascending: true);

      return AttendanceLaborModel.fromSupabaseList(attendance);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<AttendanceLaborModel> getLaborerAttendanceByID(int id) async {
    try {
      final attendance = await supabase
          .from('Employee')
          .select('''
          *,
          Position!inner(*),
          Attendance!left(*, AttendanceDetail(*))
          ''')
          .eq('Employee.employee_id', id).single();

      return AttendanceLaborModel.fromSupabase(attendance);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> storeLaborerAttendance(
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
      double weightScore = (1 - (finalWeight! / initialWeight!)) * 100;
      double qtyScore = (finalQty! / initialQty!) * 100;
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      DateTime now = DateTime.now();
      DateTime currentDateTime = DateTime(parsedDate.year, parsedDate.month,
          parsedDate.day, now.hour, now.minute, now.second);
      String parsedCurrentDate = currentDateTime.toIso8601String();

      final List<Map<String, dynamic>> attendance = await supabase
          .from('Attendance')
          .insert({
        'status': 1,
        'date': parsedCurrentDate,
        'employee_id': model.employeeId
      }).select();

      final List<Map<String, dynamic>> attendanceDetail =
          await supabase.from('AttendanceDetail').insert({
        'attendance_id': attendance[0]['attendance_id'],
        'work_type': type,
        'work_status': status,
        'initial_qty': initialQty,
        'final_qty': finalQty,
        'initial_weight': initialWeight,
        'final_weight': finalWeight,
        'cleanliness_score': cleanScore,
        'depreciation_score': weightScore,
        'shape_score': qtyScore,
      }).select();
    } catch (e) {
      throw Exception(e);
    }
  }
}
