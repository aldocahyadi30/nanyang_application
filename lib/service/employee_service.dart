import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getEmployee() async {
    try {
      final data = await supabase.from('karyawan').select('''
        *,
        posisi!inner(*)
      ''').order('nama', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<int>> getEmployeeCount() async {
    try {
      final worker = await supabase
          .from('karyawan')
          .select('''id_karyawan, posisi!inner(tipe)''')
          .eq('posisi.tipe', 1)
          .count();
      final labor = await supabase
          .from('karyawan')
          .select('''id_karyawan, posisi!inner(tipe)''')
          .eq('posisi.tipe', 2)
          .count();

      return [worker.count, labor.count];
    } on PostgrestException catch (error) {
      debugPrint('Employee error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Employee error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}