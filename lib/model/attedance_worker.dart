class AttedanceWorkerModel {
  final int employeeId;
  final String employeeName;
  final int? attendanceId;
  final int? status;
  final int? type;
  final String? date;
  final String? time;

  AttedanceWorkerModel({
    this.attendanceId,
    required this.employeeId,
    required this.employeeName,
    this.status,
    this.type,
    this.date,
    this.time,
  });

  static List<AttedanceWorkerModel> fromSupabaseList(
      List<Map<String, dynamic>> employees,
      List<Map<String, dynamic>> attendances) {
    return employees.map((employee) {
      var attendance = attendances.firstWhere(
        (attendance) => attendance['employee_id'] == employee['employee_id'],
        orElse: () => {},
      );
      var dateTemp = '';
      var timeTemp = '';
      if (attendance['date'] != null) {
        var dateComponent = attendance['date'].split('T');
        dateTemp = dateComponent[0];
        timeTemp = dateComponent[1];
      }
      return AttedanceWorkerModel(
        employeeId: employee['employee_id'],
        employeeName: employee['name'],
        attendanceId: attendance['attendance_id'],
        status: attendance['status'],
        type: attendance['type'],
        date: dateTemp,
        time: timeTemp,
      );
    }).toList();
  }
}
