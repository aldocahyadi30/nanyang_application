class AttendanceLaborModel {
  final int? attendanceId;
  final int employeeId;
  final String employeeName;
  final int? type;
  final int? status;
  final int? initialQty;
  final int? finalQty;
  final double? initialWeight;
  final double? finalWeight;
  final double? depreciationScore;
  final double? cleanlinessScore;
  final double? shapeScore;
  final String? date;

  AttendanceLaborModel({
    this.attendanceId,
    required this.employeeId,
    required this.employeeName,
    this.type,
    this.status,
    this.initialQty,
    this.finalQty,
    this.initialWeight,
    this.finalWeight,
    this.depreciationScore,
    this.cleanlinessScore,
    this.shapeScore,
    this.date,
  });

  static List<AttendanceLaborModel> fromSupabaseList(
      List<Map<String, dynamic>> attendances) {
    return attendances.map((attendance) {
      var attendanceValid = attendance['Attendance'] is List &&
          attendance['Attendance'].isNotEmpty;

      var detailValid = attendanceValid &&
          attendance['Attendance'][0]['AttendanceDetail'] is List &&
          attendance['Attendance'][0]['AttendanceDetail'].isNotEmpty;

      var status = 0;
      if (detailValid) {
        var temp =
            attendance['Attendance'][0]['AttendanceDetail'][0]['work_status'];
        if (temp == 'tugasBaru') {
          status = 1;
        } else if (temp == 'tugasLanjut') {
          status = 2;
        } else if (temp == 'tidakHadir') {
          status = 3;
        }
      }
      return AttendanceLaborModel(
          attendanceId: attendanceValid
              ? attendance['Attendance'][0]['attendance_id']
              : null,
          employeeId: attendance['employee_id'],
          employeeName: attendance['name'],
          type: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]['work_type']
              : null,
          status: status,
          initialQty: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]
                  ['initial_qty']
              : null,
          finalQty: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]['final_qty']
              : null,
          initialWeight: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]
                      ['initial_weight']
                  .toDouble()
              : null,
          finalWeight: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]
                      ['final_weight']
                  .toDouble()
              : null,
          depreciationScore: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]
                      ['depreciation_score']
                  .toDouble()
              : null,
          cleanlinessScore: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]
                      ['cleanliness_score']
                  .toDouble()
              : null,
          shapeScore: detailValid
              ? attendance['Attendance'][0]['AttendanceDetail'][0]
                      ['shape_score']
                  .toDouble()
              : null,
          date: attendanceValid ? attendance['Attendance'][0]['date'] : null);
    }).toList();
  }

  static AttendanceLaborModel fromSupabase(Map<String, dynamic> attendance) {
    var attendanceValid =
        attendance['Attendance'] is List && attendance['Attendance'].isNotEmpty;

    var detailValid = attendanceValid &&
        attendance['Attendance'][0]['AttendanceDetail'] is List &&
        attendance['Attendance'][0]['AttendanceDetail'].isNotEmpty;

    var status = 0;
    if (detailValid) {
      var temp =
          attendance['Attendance'][0]['AttendanceDetail'][0]['work_status'];
      if (temp == 'tugasBaru') {
        status = 1;
      } else if (temp == 'tugasLanjut') {
        status = 2;
      } else if (temp == 'tidakHadir') {
        status = 3;
      }
    }
    return AttendanceLaborModel(
        attendanceId: attendanceValid
            ? attendance['Attendance'][0]['attendance_id']
            : null,
        employeeId: attendance['employee_id'],
        employeeName: attendance['name'],
        type: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]['work_type']
            : null,
        status: status,
        initialQty: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]['initial_qty']
            : null,
        finalQty: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]['final_qty']
            : null,
        initialWeight: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]
                    ['initial_weight']
                .toDouble()
            : null,
        finalWeight: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]['final_weight']
                .toDouble()
            : null,
        depreciationScore: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]
                    ['depreciation_score']
                .toDouble()
            : null,
        cleanlinessScore: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]
                    ['cleanliness_score']
                .toDouble()
            : null,
        shapeScore: detailValid
            ? attendance['Attendance'][0]['AttendanceDetail'][0]['shape_score']
                .toDouble()
            : null,
        date: attendanceValid ? attendance['Attendance'][0]['date'] : null);
  }
}
