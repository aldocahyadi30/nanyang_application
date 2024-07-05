import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarService{
  SupabaseClient supabase = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> getHoliday(String startDate, String endDate){
    try {
      final data = supabase.from('hari_libur').select('*').gte('tanggal', startDate).lte('tanggal', endDate);
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}