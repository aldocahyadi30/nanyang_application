import 'package:nanyang_application/model/announcement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getDashboardAnnouncement() async {
    try {
      final data = await supabase.from('pengumuman').select('''
        *,
        pengumuman_kategori!inner(*),
        karyawan!inner(*, posisi!inner(*))
      ''').order('waktu_kirim', ascending: false).limit(2);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAnnouncement() async {
    try {
      final data = await supabase.from('pengumuman').select('''
        *,
        pengumuman_kategori!inner(*),
        karyawan!inner(*, posisi!inner(*))
      ''').order('waktu_kirim', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAnnouncementByCategory(List<int> categoryID) async {
    try {
      final data = await supabase.from('pengumuman').select('''
        *,
        pengumuman_kategori!inner(*)
      ''').inFilter('id_kategori', categoryID).order('tanggal_post', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAnnouncementCategory() async {
    try {
      final data = await supabase.from('pengumuman_kategori').select('*').order('id_kategori', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> storeAnnouncement(AnnouncementModel model) async {
    try {
      await supabase.from('pengumuman').insert({
        'id_kategori': model.category.id,
        'judul': model.title,
        'isi': model.content,
        'waktu_kirim': model.postDate?.toIso8601String(),
        'durasi': model.duration,
        'status': model.status,
        'sudah_kirim': model.isSend,
        'id_pembuat': model.employee.id,
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel model) async {
    try {
      await supabase.from('pengumuman').update({
        'id_kategori': model.category.id,
        'judul': model.title,
        'isi': model.content,
        'waktu_kirim': model.postDate!.toIso8601String(),
        'durasi': model.duration,
        'status': model.status,
        'waktu_update': DateTime.now().toIso8601String(),
      }).eq('id_pengumuman', model.id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  Future<void> deleteAnnouncement(int id) async {
    try {
      await supabase.from('pengumuman').delete().eq('id_pengumuman', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
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
      throw PostgrestException(message: error.message);
    } catch (e) {
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
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}