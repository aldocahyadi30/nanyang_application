import 'dart:convert';

import 'package:nanyang_application/model/announcement_category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class ConfigurationService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getConfiguration() async {
    try {
      final data = await supabase.from('konfigurasi').select('*');
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateSalaryConfiguration(double foodAllowanceWorker, double foodAllowanceLabor, int day ) async{
    try{
      await supabase.from('konfigurasi').update({'value': foodAllowanceWorker}).eq('nama_konfigurasi', 'uang_makan_karyawan');
      await supabase.from('konfigurasi').update({'value': foodAllowanceLabor}).eq('nama_konfigurasi', 'uang_makan_cabutan');
      await supabase.from('konfigurasi').update({'value': day}).eq('nama_konfigurasi', 'tanggal_cutoff');
    }on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePerformanceThreshold(double value) async{
    try{
      await supabase.from('konfigurasi').update({'value': value}).eq('nama_konfigurasi', 'batas_performa');
    }on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<
  Future<List<dynamic>> getHolidayByAPI() async {
    try {
      var uri = Uri.https('api-harilibur.vercel.app', '/api');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getHolidayByDB(String startDate, String endDate) async {
    try {
      final data = await supabase.from('hari_libur').select('*').gte('tanggal', startDate).lte('tanggal', endDate);
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveHoliday(String name, String date) async {
    try {
      await supabase.from('hari_libur').insert([
        {'nama': name, 'tanggal': date}
      ]);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteHoliday(int id) async {
    try {
      await supabase.from('hari_libur').delete().eq('id_hari', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getPosition() async {
    try {
      final data = await supabase.from('posisi').select('*');
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> savePosition(String name, int type) async {
    try {
      await supabase.from('posisi').insert([
        {'nama': name, 'tipe': type}
      ]);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deletePosition(int id) async {
    try {
      await supabase.from('posisi').delete().eq('id_posisi', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePosition(int id, String name, int type) async {
    try {
      await supabase.from('posisi').update({'nama': name, 'tipe': type}).eq('id_posisi', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String,dynamic>>> getAnnouncementCategory() async {
    try {
      final data = await supabase.from('pengumuman_kategori').select('*').order('id_kategori', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> storeAnnouncementCategory(AnnouncementCategoryModel model) async {
    try {
      await supabase.from('pengumuman_kategori').insert({
        'nama': model.name,
        'kode_warna': model.color.value.toRadixString(16),
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateAnnouncementCategory(AnnouncementCategoryModel model) async {
    try {
      await supabase.from('pengumuman_kategori').update({
        'nama': model.name,
        'kode_warna': model.color.value.toRadixString(16),
      }).eq('id_kategori', model.id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteAnnouncementCategory(int id) async {
    try {
      await supabase.from('pengumuman_kategori').delete().eq('id_kategori', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}