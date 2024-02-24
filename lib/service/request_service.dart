import 'package:nanyang_application/model/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<RequestModel>> getDashboardRequest() async {
    try {
      final data = await supabase.from('AttendanceRequest').select('''
        request_id,
        status,
        start_date,
        end_date,
        reason,
        comment,
        post_later,
        AttendanceRequestType(
          request_type_id,
          name,
        ),
        Employee!employee_id(
          user_id,
          name,
        ),
        Approver:approver_id(
          user_id,
          name,
        )
        ''').order('created_date', ascending: false).limit(2);

      return RequestModel.fromSupabaseList(data);
    } catch (e) {
      throw Exception('Get annoucement failed');
    }
  }
}
