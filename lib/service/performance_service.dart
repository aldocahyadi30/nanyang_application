import 'package:supabase_flutter/supabase_flutter.dart';

class PerformanceService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<dynamic>> getAttendanceCount(String startDate, String endDate) async {
    try {
      final data = await supabase.rpc('get_attendance_count', params: {'start_date': startDate, 'end_date': endDate});

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> getLaborQuote(int employeeID, String startDate, String endDate) async {
    try {
      final data = await supabase
          .rpc('get_labor_quote', params: {'emp_id': employeeID, 'start_date': startDate, 'end_date': endDate});

      print(data);
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getLaborProduction(String startTime, String endTime) async{
    try {
      final data = await supabase.from('karyawan').select('''
      *,
      posisi!inner(*),
      absensi!left(*, absensi_detail(nilai_performa))
      ''').eq('posisi.tipe', 2).gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).order('nama', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}