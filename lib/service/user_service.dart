import 'package:nanyang_application/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService{
  SupabaseClient supabase = Supabase.instance.client;

  Future<UserModel> getUserByID(String id) async {
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
        ''').eq('user_id', id);

      return UserModel.fromSupabase(data[0]);
    } catch (e) {
      throw Exception('Get user failed');
    }
  }
}