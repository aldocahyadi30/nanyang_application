import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getChat() async {
    try {
      final data = await supabase.from('chat').select('''
        id_chat,
        user!inner(*),
        pesan!inner(*)
        ''').order('pesan.waktu_kirim', referencedTable: 'pesan', ascending: false).limit(1, referencedTable: 'pesan');
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<SupabaseStreamBuilder> getMessage(String userID) async {
    try {
      final chatID = await supabase.from('chat').select('''id_chat, user!inner(id_user)''').eq('user.id_user', userID).single();

      final stream = supabase.from('pesan').stream(primaryKey: ['id_pesan']).eq('id_chat', chatID['id_chat']).order('waktu_kirim', ascending: false);

      return stream;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
