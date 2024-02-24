import 'package:nanyang_application/model/attedance_worker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<AttedanceWorkerModel>> getWorkerAttedance(String date) async {
    try {
      final starTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final employeeData =
          await Supabase.instance.client.from('Employee').select('*');

      final attendanceData = await Supabase.instance.client
          .from('Attendance')
          .select('*')
          .gte('date', starTime)
          .lte('date', endTime);

      return AttedanceWorkerModel.fromSupabaseList(employeeData, attendanceData);
    } catch (e) {
      throw Exception(e);
    }
  }
}
