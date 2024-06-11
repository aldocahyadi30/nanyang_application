import 'dart:io';

class MessageModel {
  final int id;
  final String userId;
  final String? message;
  final String? filePath;
  final File? file;
  final bool isAdmin;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.userId,
    this.message,
    this.file,
    this.filePath,
    required this.isAdmin,
    required this.timestamp,
  });

  factory MessageModel.fromSupabase(Map<String, dynamic> message) {
    return MessageModel(
      id: message['id_pesan'],
      userId: message['id_user'],
      message: message['pesan'],
      isAdmin: message['is_admin'],
      timestamp: DateTime.parse(message['waktu_kirim']),
    );
  }

  static List<MessageModel> fromSupabaseList(List<Map<String, dynamic>> messages) {
    return messages.map((message) => MessageModel.fromSupabase(message)).toList();
  }

  factory MessageModel.empty() {
    return MessageModel(
      id: 0,
      userId: '',
      message: '',
      isAdmin: false,
      timestamp: DateTime.now(),
    );
  }
}
