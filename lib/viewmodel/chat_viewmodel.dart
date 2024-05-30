import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/message.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final ConfigurationProvider _configurationProvider = Provider.of<ConfigurationProvider>(navigatorKey.currentContext!, listen: false);
  List<MessageModel> messages = [];

  ChatViewModel({required ChatService chatService}) : _chatService = chatService;

  Future<SupabaseStreamBuilder?> getMessageStream() async {
    try {
      final stream = await _chatService.getMessage(_configurationProvider.user.id);

      return stream;
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Message error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Get Message error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return null;
    }
  }
}
