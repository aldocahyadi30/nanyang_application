import 'package:nanyang_application/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  SupabaseClient supabase = Supabase.instance.client;
  Future<UserModel> login(String email, String password) async {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final User? user = res.user;
    if (user == null) {
      throw Exception('Login failed');
    } else {
      try {
        final data = await supabase.from('User').select('''
        user_id,
        email,
        level,
        Employee!public_Employee_employee_id_fkey (
          employee_id,
          name,
          age,
          Position!public_Employee_position_id_fkey (
            position_id,
            name
          )
        )
        ''').eq('user_id', user.id);

        return UserModel.fromSupabase(data[0]);
      } catch (e) {
        throw Exception('Login failed');
      }
    }
  }
}
