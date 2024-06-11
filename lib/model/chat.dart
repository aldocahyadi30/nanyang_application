import 'package:nanyang_application/model/message.dart';
import 'package:nanyang_application/model/user.dart';

class ChatModel {
  final int id;
  final int unreadCount;
  final UserModel user;
  final MessageModel lastMessage;

  ChatModel({
    required this.id,
    required this.unreadCount,
    required this.user,
    required this.lastMessage,
  });

  factory ChatModel.fromMap(Map<String, dynamic> chat) {
    return ChatModel(
      id: chat['id_chat'],
      unreadCount: chat['jumlah_belum_dibaca'],
      user: UserModel.fromSupabase(chat['user'][0]),
      lastMessage: MessageModel.fromSupabase(chat['pesan'][0]),
    );
  }

  static List<ChatModel> fromMapList(List<Map<String, dynamic>> chats) {
    return chats.map((chat) => ChatModel.fromMap(chat)).toList();
  }

  factory ChatModel.empty() {
    return ChatModel(
      id: 0,
      unreadCount: 0,
      user: UserModel.empty(),
      lastMessage: MessageModel.empty(),
    );
  }
}
