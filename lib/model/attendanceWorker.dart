class AttendanceWorkerModel {
  final int employeeId;
  final String employeeName;
  final int? attendanceId;
  final int? status;
  final int? type;
  final String? date;
  final String? time;

  AttendanceWorkerModel({
    this.attendanceId,
    required this.employeeId,
    required this.employeeName,
    this.status,
    this.type,
    this.date,
    this.time,
  });

  static List<AttendanceWorkerModel> fromSupabaseList(
      List<Map<String, dynamic>> attendances) {
    return attendances.map((attendance) {
      var dateTemp = '';
      var timeTemp = '';
      if (attendance['Attendance'] is List && attendance['Attendance'].isNotEmpty && attendance['Attendance'][0]['date'] != null) {
        var dateComponent = attendance['Attendance'][0]['date'].split('T');
        dateTemp = dateComponent[0];
        timeTemp = dateComponent[1];
      }
      return AttendanceWorkerModel(
        employeeId: attendance['employee_id'],
        employeeName: attendance['name'],
        attendanceId: attendance['Attendance'] is List && attendance['Attendance'].isNotEmpty ? attendance['Attendance'][0]['attendance_id'] : null,
        status: attendance['Attendance'] is List && attendance['Attendance'].isNotEmpty ? attendance['Attendance'][0]['status'] : null,
        type: attendance['Attendance'] is List && attendance['Attendance'].isNotEmpty ? attendance['Attendance'][0]['type'] : null,
        date: dateTemp,
        time: timeTemp,
      );
    }).toList();
  }
}
