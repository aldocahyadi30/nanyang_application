class UserModel {
  final String id;
  final int employeeId;
  final String email;
  final String name;
  final int level;
  final int positionId;
  final String positionName;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.level,
    required this.employeeId,
    required this.positionId,
    required this.positionName,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> user) {
    return UserModel(
      id: user['user_id'],
      email: user['email'],
      name: user['Employee']['name'],
      level: user['level'],
      employeeId: user['Employee']['employee_id'],
      positionId: user['Employee']['Position']['position_id'],
      positionName: user['Employee']['Position']['name'],
    );
  }
}