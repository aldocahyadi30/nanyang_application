import 'dart:io';
import 'dart:typed_data';

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
        *,
        user!inner(*,karyawan!inner(*, posisi!inner(*))),
        pesan!inner(*)
      ''').inFilter('id_chat', chatIds).limit(1, referencedTable: 'pesan').order('waktu_kirim', referencedTable: 'pesan', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendMessage(int chatID, String userID, bool isAdmin, {String? message, File? file}) async {
    try {
      String? path;
      if (file != null) {
        String fileName = file.path.split('/').last;
        path = await supabase.storage.from('chat').upload(
              '$chatID/$fileName',
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      }

      await supabase.from('pesan').insert({
        'id_chat': chatID,
        'id_user': userID,
        'is_admin': isAdmin,
        'pesan': message,
        'file': path,
        'waktu_kirim': DateTime.now().toIso8601String(),
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Uint8List> downloadFile(String path) async {
    try {
      String bucketID = path.split('/')[0];
      String objectPath = path.split('/').sublist(1).join('/');
      Uint8List file = await supabase.storage.from(bucketID).download(objectPath);
      return file;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
