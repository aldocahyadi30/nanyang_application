import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  SupabaseClient supabase = Supabase.instance.client;

  SupabaseStreamBuilder getAdminMessage() {
    try {
      final stream = supabase.from('chat').stream(primaryKey: ['id_chat']);

      return stream;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  SupabaseStreamBuilder getUserMessage(int chatID) {
    try {
      final stream = supabase.from('pesan').stream(primaryKey: ['id_pesan']).eq('id_chat', chatID).order('waktu_kirim', ascending: false);

      return stream;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAdminChatList(List<dynamic> chatIds) async {
    try {
      final data = await supabase.from('chat').select('''
        id_chat,
        jumlah_belum_dibaca,
        user!inner(id_user, karyawan!inner(nama, posisi!inner(tipe))),
        pesan!inner(*)
      ''').inFilter('id_chat', chatIds).limit(1, referencedTable: 'pesan').order('waktu_kirim', referencedTable: 'pesan', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendMessage(int chatID, String userID, bool isAdmin, {String? meesage, File? file}) async {
    try {
      await supabase.from('pesan').insert({
        'id_chat': chatID,
        'id_user': userID,
        'is_admin': isAdmin,
        'pesan': meesage,
        'file': file,
        'waktu_kirim': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
