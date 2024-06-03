class MessageModel {
  final int id;
  final String userId;
  final String? message;
  final String? file;
  final bool isAdmin;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.userId,
    this.message,
    this.file,
    required this.isAdmin,
    required this.timestamp,
  });

  factory MessageModel.fromSupabase(Map<String, dynamic> message) {
    return MessageModel(
      id: message['id_pesan'],
      userId: message['id_user'],
    message: message['pesan'],
      file: message['file'],
      isAdmin: message['is_admin'],
      timestamp: DateTime.parse(message['waktu_kirim']),
    );
  }

  static List<MessageModel> fromSupabaseList(List<Map<String, dynamic>> messages) {
    return messages.map((message) => MessageModel.fromSupabase(message)).toList();
  }
}
