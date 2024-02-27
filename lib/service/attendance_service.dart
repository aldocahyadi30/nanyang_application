import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<AttendanceWorkerModel>> getWorkerAttedance(String date) async {
    try {
      final starTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final employeeData =
          await Supabase.instance.client.from('Employee').select('''
          *,
          Position!inner(*)
          ''').eq('Position.type', 1);

      final attendanceData = await Supabase.instance.client
          .from('Attendance')
          .select('*')
          .gte('date', starTime)
          .lte('date', endTime);

      return AttendanceWorkerModel.fromSupabaseList(
          employeeData, attendanceData);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<AttendanceLaborModel>> getLaborerAttendance(String date) async {
    try {
      final starTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final employeeData =
          await Supabase.instance.client.from('Employee').select('''
          *,
          Position!inner(*)
          ''').eq('Position.type', 2);

      final attendanceData = await Supabase.instance.client
          .from('Attendance')
          .select('*, AttendanceDetail(*)')
          .gte('date', starTime)
          .lte('date', endTime);

      print(employeeData);

      return AttendanceLaborModel.fromSupabaseList(
          employeeData, attendanceData);
    } catch (e) {
      throw Exception(e);
    }
  }
}
