import 'package:nanyang_application/model/announcement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<AnnouncementModel>> getDashboardAnnoucement() async {
    try {
      final data = await supabase.from('Annoucement').select('''
        announcement_id,
        title,
        description,
        post_date,
        post_later,
        AnnoucementCategory!Announcement_category_id_AnnouncementCategory_category_id (
          category_id,
          name,
          age,
        )
        ''').order('created_date', ascending: false).limit(2);

      return AnnouncementModel.fromSupabaseList(data);
    } catch (e) {
      throw Exception('Get annoucement failed');
    }
  }
}
