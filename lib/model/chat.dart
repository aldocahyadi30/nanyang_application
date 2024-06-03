class ChatModel {
  final int id;
  final String userId;
  final String employeeName;
  final String shortedName;
  final String initials;
  final int employeePosition;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.userId,
    required this.employeeName,
    required this.shortedName,
    required this.initials,
    required this.employeePosition,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatModel.fromMap(Map<String, dynamic> chat) {
    String name = chat['user'][0]['karyawan']['nama'];
    List<String> nameParts = name.split(' ');
    String shortedName = '';
    String initials = '';

    if (nameParts.length == 1) {
      shortedName = nameParts[0];
    } else if (nameParts.length == 2) {
      shortedName = nameParts.join(' ');
    } else {
      shortedName = nameParts.take(2).join(' ') + nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
    }

    initials =
        ((nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0][0] : '') + (nameParts.length > 1 && nameParts[1].isNotEmpty ? nameParts[1][0] : ''))
            .toUpperCase();
    return ChatModel(
      id: chat['id_chat'],
      userId: chat['user'][0]['id_user'],
      employeeName: name,
      shortedName: shortedName,
      initials: initials,
      employeePosition: chat['user'][0]['karyawan']['posisi']['tipe'],
      lastMessage: chat['pesan'][0]['pesan'],
      lastMessageTime: DateTime.parse(chat['pesan'][0]['waktu_kirim']),
      unreadCount: chat['jumlah_belum_dibaca'],
    );
  }

  static List<ChatModel> fromMapList(List<Map<String, dynamic>> chats) {
    return chats.map((chat) => ChatModel.fromMap(chat)).toList();
  }
}
