import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getUser() async {
    try {
      final data = await supabase
          .from('user')
          .select('''*, karyawan(*, posisi(*)) ''').order('email', ascending: true);
          print(data);
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getUserByID(String id) async {
    try {
      final data = await supabase.from('user').select('''
        *,
        karyawan(*,
          posisi(*
          )
        )
        ''').eq('id_user', id).single();

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}