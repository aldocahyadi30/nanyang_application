import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  SupabaseClient supabase = Supabase.instance.client;
  final adminSupabase = SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_SERVICE_KEY']!);

  Future<bool> login(String email, String password, String? token) async {
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

          await supabase.from('fcm').upsert({
            'id_user': user.id,
            'token': token,
            'tanggal_dibuat': DateTime.now().toIso8601String(),
          }, onConflict: 'id_user');

          return true;
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

  Future<void> register(UserModel model, String password) async {
    try {
      Map<String, dynamic>? chatID;
      final res = await adminSupabase.auth.admin.createUser(AdminUserAttributes(
        email: model.email,
        password: password,
        emailConfirm: true,
      ));

      if (model.level == 1) chatID = await supabase.from('chat').insert({}).select('id_chat').single();

      await supabase.from('user').insert({
        'id_user': res.user!.id,
        'email': model.email,
        'id_karyawan': model.employee.id,
        'level': model.level,
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

  Future<void> update(UserModel model) async {
    try {
      await adminSupabase.auth.admin.updateUserById(model.id,
          attributes: AdminUserAttributes(
            email: model.email,
          ));

      await supabase.from('user').update({
        'email': model.email,
        'id_karyawan': model.employee.id,
        'level': model.level,
      }).eq('id_user', model.id);
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

  Future<void> logout(String? token) async {
    try {
      await supabase.from('fcm').delete().eq('token', token!).eq('id_user', supabase.auth.currentUser!.id); 


      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<dynamic> sendOTP(String email, String phone) async {
  //   try {
  //     final otp = await supabase.auth.resend(type: OtpType.sms, phone: phone);
  //     return otp;
  //   } on AuthException catch (e) {
  //     throw AuthException(e.message);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }
}