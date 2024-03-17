import 'package:flutter/cupertino.dart';
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
        *,
        AnnouncementCategory!inner(*)
      ''').order('post_date', ascending: false).limit(2);

      return AnnouncementModel.fromSupabaseList(data);
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<AnnouncementModel>> getAnnouncement() async {
    try {
      final data = await supabase.from('Announcement').select('''
        *,
        AnnouncementCategory!inner(*)
      ''').order('post_date', ascending: false);

      return AnnouncementModel.fromSupabaseList(data);
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
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
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> storeAnnouncement(int categoryId, String title, String content, bool postLater, DateTime dateTime) async {
    try {
      await supabase.from('Announcement').insert({
        'category_id': categoryId,
        'title': title,
        'description': content,
        'post_later': postLater,
        'post_date': dateTime.toIso8601String(),
        'created_by': Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false).user!.employeeId,
      });
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}