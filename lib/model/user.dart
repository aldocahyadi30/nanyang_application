import 'package:nanyang_application/model/employee.dart';

class UserModel {
  final String id;
  String email;
  int level;
  final int userChatId;
  EmployeeModel employee;
  bool isAdmin;

  UserModel({
    required this.id,
    required this.email,
    required this.level,
    this.userChatId = 0,
    required this.employee,
    this.isAdmin = false,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> user) {
    int userChatId = 0;
    bool isAdmin = false;
    if (user['level'] == 1 && user['id_chat'] != null) {
      userChatId = user['id_chat'];
    }

    if (user['level'] != 1) {
      isAdmin = true;
    }
    return UserModel(
        id: user['id_user'],
        email: user['email'],
        level: user['level'],
        userChatId: userChatId,
        employee: EmployeeModel.fromSupabase(user['karyawan']),
        isAdmin: isAdmin);
  }

  static List<UserModel> fromSupabaseList(List<Map<String, dynamic>> users) {
    return users.map((user) => UserModel.fromSupabase(user)).toList();
  }

  factory UserModel.empty() {
    return UserModel(id: '', email: '', level: 0, employee: EmployeeModel.empty());
  }

  factory UserModel.copyWith(UserModel user) {
    return UserModel(
        id: user.id,
        email: user.email,
        level: user.level,
        userChatId: user.userChatId,
        employee: user.employee,
        isAdmin: user.isAdmin);
  }
}