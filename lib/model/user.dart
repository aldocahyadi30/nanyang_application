import 'package:nanyang_application/model/employee.dart';

class UserModel {
  final String id;
  String email;
  int level;
  final int userChatId;
  EmployeeModel employee;

  UserModel({
    required this.id,
    required this.email,
    required this.level,
    this.userChatId = 0,
    required this.employee,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> user) {
    int userChatId = 0;
    if (user['level'] == 1 && user['id_chat'] != null) {
      userChatId = user['id_chat'];
    }

    return UserModel(
        id: user['id_user'], email: user['email'], level: user['level'], userChatId: userChatId, employee: EmployeeModel.fromSupabase(user['karyawan']));
  }

  static List<UserModel> fromSupabaseList(List<Map<String, dynamic>> users) {
    return users.map((user) => UserModel.fromSupabase(user)).toList();
  }

  factory UserModel.empty() {
    return UserModel(id: '', email: '', level: 0, employee: EmployeeModel.empty());
  }
}
