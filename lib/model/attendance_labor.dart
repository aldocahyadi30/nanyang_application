class AttendanceLaborModel {
  final int? attendanceId;
  final int employeeId;
  final String employeeName;
  final int? workType;
  final int? workStatus;
  final int? qty;
  final double? totalWeight;
  final double? depreciationScore;
  final double? cleanlinessScore;
  final double? shapeScore;
  final String? date;

  AttendanceLaborModel({
    this.attendanceId,
    required this.employeeId,
    required this.employeeName,
    this.workType,
    this.workStatus,
    this.qty,
    this.totalWeight,
    this.depreciationScore,
    this.cleanlinessScore,
    this.shapeScore,
    this.date,
  });

  static List<AttendanceLaborModel> fromSupabaseList(
      List<Map<String, dynamic>> employees,
      List<Map<String, dynamic>> attendances) {
    return employees.map((employee) {
      var attendance = attendances.firstWhere(
        (attendance) => attendance['employee_id'] == employee['employee_id'],
        orElse: () => {},
      );
      return AttendanceLaborModel(
          attendanceId: attendance['attendance_id'],
          employeeId: employee['employee_id'],
          employeeName: employee['name'],
          workType: attendance['AttedanceDetail']?['work_type'],
          workStatus: attendance['AttedanceDetail']?['work_status'],
          qty: attendance['AttedanceDetail']?['qty'],
          totalWeight: attendance['AttedanceDetail']?['total_weight'],
          depreciationScore: attendance['AttedanceDetail']
              ?['depreciation_score'],
          cleanlinessScore: attendance['AttedanceDetail']?['cleanliness_score'],
          shapeScore: attendance['AttedanceDetail']?['shape_score'],
          date: attendance['created_date']);
    }).toList();
  }
}
