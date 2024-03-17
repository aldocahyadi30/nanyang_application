import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<AttendanceWorkerModel>> getWorkerAttedanceByDate(String date) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final attendance = await Supabase.instance.client.from('Employee').select('''
          *,
          Position!inner(*),
          Attendance!left(*)
          ''').eq('Position.type', 1).gte('Attendance.date', startTime).lte('Attendance.date', endTime).order('name', ascending: true);
      return AttendanceWorkerModel.fromSupabaseList(attendance);
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<AttendanceLaborModel>> getLaborAttendanceByDate(String date) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final attendance = await Supabase.instance.client.from('Employee').select('''
          *,
          Position!inner(*),
          Attendance!left(*, AttendanceDetail(*))
          ''').eq('Position.type', 2).gte('Attendance.date', startTime).lte('Attendance.date', endTime).order('name', ascending: true);

      return AttendanceLaborModel.fromSupabaseList(attendance);
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<AttendanceLaborModel> getLaborAttendanceByID(int id) async {
    try {
      final attendance = await supabase.from('Employee').select('''
          *,
          Position!inner(*),
          Attendance!left(*, AttendanceDetail(*))
          ''').eq('Employee.employee_id', id).single();

      return AttendanceLaborModel.fromSupabase(attendance);
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> storeLaborAttendance(AttendanceLaborModel model, String date, String status, int type, int? initialQty, int? finalQty, double? initialWeight,
      double? finalWeight, int? cleanScore) async {
    try {
      double weightScore = (1 - (finalWeight! / initialWeight!)) * 100;
      double qtyScore = (finalQty! / initialQty!) * 100;
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      DateTime now = DateTime.now();
      DateTime currentDateTime = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, now.hour, now.minute, now.second);
      String parsedCurrentDate = currentDateTime.toIso8601String();

      final List<Map<String, dynamic>> attendance =
          await supabase.from('Attendance').insert({'status': 1, 'date': parsedCurrentDate, 'employee_id': model.employeeId}).select();

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
      });
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}