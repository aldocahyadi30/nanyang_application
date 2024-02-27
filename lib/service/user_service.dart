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
        Employee(
          employee_id,
          name,
          age,
          Position(
            position_id,
            name
          )
        )
        ''').eq('user_id', id);

      return UserModel.fromSupabase(data[0]);
    } catch (e) {
      throw Exception(e);
    }
  }
}