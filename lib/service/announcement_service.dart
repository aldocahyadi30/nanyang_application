import 'package:flutter/cupertino.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String,dynamic>>> getDashboardAnnouncement() async {
    try {
      final data = await supabase.from('pengumuman').select('''
        *,
        pengumuman_kategori!inner(*),
        karyawan!inner(*, posisi!inner(*))
      ''').order('tanggal_post', ascending: false).limit(2);


      return data;
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String,dynamic>>> getAnnouncement() async {
    try {
      final data = await supabase.from('pengumuman').select('''
        *,
        pengumuman_kategori!inner(*),
        karyawan!inner(*, posisi!inner(*))
      ''').order('waktu_kirim', ascending: false);



      return data;
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String,dynamic>>> getAnnouncementByCategory(List<int> categoryID) async {
    try {
      final data = await supabase.from('pengumuman').select('''
        *,
        pengumuman_kategori!inner(*)
      ''').inFilter('id_kategori', categoryID).order('tanggal_post', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String,dynamic>>> getAnnouncementCategory() async {
    try {
      final data = await supabase.from('pengumuman_kategori').select('*').order('id_kategori', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  //TODO Need to refactor this
  Future<void> storeAnnouncement(
      int categoryId, String title, String content, DateTime dateTime, int duration, bool isPosted) async {
    try {
      await supabase.from('pengumuman').insert({
        'id_kategori': categoryId,
        'judul': title,
        'isi': content,
        'waktu_kirim': dateTime.toIso8601String(),
        'durasi' : duration,
        'sudah_kirim': isPosted,
        'id_pembuat': Provider.of<ConfigurationProvider>(navigatorKey.currentContext!, listen: false).user.employee.id,
      });
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> storeAnnouncementCategory(String title, String color) async {
    try {
      await supabase.from('AnnouncementCategory').insert({
        'name': title,
        'color': color,
      });
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> updateAnnouncementCategory(int id, String title, String color) async {
    try {
      await supabase.from('AnnouncementCategory').update({
        'name': title,
        'color': color,
      }).eq('category_id', id);
    } on PostgrestException catch (error) {
      debugPrint('Announcement error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Announcement error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}