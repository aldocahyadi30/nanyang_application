import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nanyang_application/model/chat.dart';
import 'package:nanyang_application/service/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService;

  ChatViewModel({required ChatService chatService}) : _chatService = chatService;

  SupabaseStreamBuilder? getMessageStream(int chatID) {
    try {
      final stream = _chatService.getUserMessage(chatID);

      return stream;
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Message error: ${e.message}');
      } else {
        debugPrint('Get Message error: ${e.toString()}');
      }
      return null;
    }
  }

  SupabaseStreamBuilder? getChatStream() {
    try {
      final stream = _chatService.getAdminMessage();

      return stream;
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Message error: ${e.message}');
      } else {
        debugPrint('Get Message error: ${e.toString()}');
      }
      return null;
    }
  }

  Future<List<ChatModel>> getChat(List<Map<String, dynamic>> chats) async {
    try {
      List<Map<String, dynamic>> data = await _chatService.getAdminChatList(chats.map((e) => e['id_chat']).toList());

      return ChatModel.fromMapList(data);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Chat: ${e.message}');
      } else {
        debugPrint('Get Chat error: ${e.toString()}');
      }
      return [];
    }
  }

  Future<void> sendMessage(int chatID, String userID, bool isAdmin, {String? meesage, File? file}) async{
    try {
      _chatService.sendMessage(chatID, userID, isAdmin, meesage: meesage, file: file);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Send Message error: ${e.message}');
      } else {
        debugPrint('Send Message error: ${e.toString()}');
      }
    }
  }

}
