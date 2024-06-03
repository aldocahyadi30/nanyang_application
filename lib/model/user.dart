class UserModel {
  final String id;
  final int employeeId;
  final String email;
  final String name;
  final String shortedName;
  final String initials;
  final int level;
  final int positionId;
  final String positionName;
  final int positionType;
  final int? userChatId;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.shortedName,
    required this.initials,
    required this.level,
    required this.employeeId,
    required this.positionId,
    required this.positionName,
    required this.positionType,
    this.userChatId,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> user) {
    String name = user['karyawan']['nama'];
    List<String> nameParts = name.split(' ');
    String shortedName = '';
    String initials = '';
    int? userChatId;

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

    if (user['level'] == 1 && user['id_chat'] != null) {
      userChatId = user['id_chat'];
    }

    return UserModel(
      id: user['id_user'],
      email: user['email'],
      name: name,
      shortedName: shortedName,
      initials: initials,
      level: user['level'],
      employeeId: user['karyawan']['id_karyawan'],
      positionId: user['karyawan']['posisi']['id_posisi'],
      positionName: user['karyawan']['posisi']['nama'],
      positionType: user['karyawan']['posisi']['tipe'],
      userChatId: userChatId,
    );
  }

  static List<UserModel> fromSupabaseList(List<Map<String, dynamic>> users) {
    return users.map((user) => UserModel.fromSupabase(user)).toList();
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      name: '',
      shortedName: '',
      initials: '',
      level: 0,
      employeeId: 0,
      positionId: 0,
      positionName: '',
      positionType: 0,
    );
  }
}
