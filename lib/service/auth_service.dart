import 'package:nanyang_application/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  SupabaseClient supabase = Supabase.instance.client;
  Future<UserModel> login(String email, String password) async {
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
          final data = await supabase.from('User').select('''
        user_id,
        email,
        level,
        Employee(
          employee_id,
          name,
          age,
          Position(
            position_id,
            name
          )
        )
        ''').eq('user_id', user.id);

          return UserModel.fromSupabase(data[0]);
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
}
