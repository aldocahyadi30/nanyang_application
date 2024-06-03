import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  SupabaseClient supabase = Supabase.instance.client;
  final adminSupabase = SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_SERVICE_KEY']!);

  Future<Map<String, dynamic>> login(String email, String password, String? token) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final User? user = res.user;
      if (user == null) {
        throw Exception('User not foumd');
      } else {
        try {
          final data = await supabase.from('user').select('''
          *,
          karyawan(
            id_karyawan,
            nama,
            posisi(
              id_posisi,
              nama,
              tipe
            )
          )
          ''').eq('id_user', user.id).single();


        await supabase.from('fcm').upsert({
            'id_user': user.id,
            'token': token,
            'tanggal_dibuat': DateTime.now().toIso8601String(),
          }, onConflict: 'id_user');



          return data;
        } on PostgrestException catch (error) {
          throw PostgrestException(message: error.message);
        } catch (e) {
          throw Exception(e.toString());
        }
      }
    } on AuthException catch (e) {
      if (e.message == 'Invalid login credentials') {
        throw const AuthException('Invalid login credentials');
      } else {
        throw Exception('Terjadi kesalahan, silahkan coba lagi');
      }
    }
  }

  Future<void> register(String email, String password, int employeeID, int level) async {
    try {
      Map<String, dynamic>? chatID;
      final res = await adminSupabase.auth.admin.createUser(AdminUserAttributes(
        email: email,
        password: password,
        emailConfirm: true,
      ));

      if (level == 1) chatID = await supabase.from('chat').insert({}).select('id_chat').single();

      await supabase.from('user').insert({
        'id_user': res.user!.id,
        'email': email,
        'id_karyawan': employeeID,
        'level': level,
        'id_chat': chatID != null ? chatID['id_chat'] : null,
      });
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update(String uid, String email, int employeeID, int level) async {
    try {
      await adminSupabase.auth.admin.updateUserById(uid,
          attributes: AdminUserAttributes(
            email: email,
          ));

      await supabase.from('user').update({
        'email': email,
        'id_karyawan': employeeID,
        'level': level,
      }).eq('id_user', uid);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> delete(String uid) async {
    try {
      await adminSupabase.auth.admin.deleteUser(uid);

      await supabase.from('user').delete().eq('id_user', uid);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}