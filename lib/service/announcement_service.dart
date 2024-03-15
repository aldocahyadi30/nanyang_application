import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<AnnouncementModel>> getDashboardAnnouncement() async {
    try {
      final data = await supabase.from('Announcement').select('''
        announcement_id,
        title,
        description,
        post_date,
        post_later,
        AnnouncementCategory!Announcement_category_id_AnnouncementCategory_category_id (
          category_id,
          name,
          age,
        )
        ''').order('created_date', ascending: false).limit(2);

      return AnnouncementModel.fromSupabaseList(data);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<AnnouncementModel>> getAnnouncement() async {
    try {
      final data = await supabase.from('Announcement').select('''
        *,
        AnnouncementCategory!inner(*)
      ''');
      print(data);

      return AnnouncementModel.fromSupabaseList(data);
    } on PostgrestException catch (error) {
      print(error.message);
      throw PostgrestException(message: error.message);
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<AnnouncementCategoryModel>> getAnnouncementCategory() async {
    try {
      final data = await supabase.from('AnnouncementCategory').select('''
        category_id,
        name
        ''');
      return AnnouncementCategoryModel.fromSupabaseList(data);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> storeAnnouncement(AnnouncementModel announcement) async {
    try {
      DateTime date = DateFormat('dd-MM-yyyy').parse(announcement.postDate);
      DateTime time = DateFormat('HH:mm').parse(announcement.postTime);
      DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

      await supabase.from('Announcement').insert({
        'category_id': announcement.categoryId,
        'title': announcement.title,
        'description': announcement.content,
        'post_later': announcement.postLater,
        'post_date': dateTime.toIso8601String(),
        'created_by': Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false).user!.employeeId,
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
