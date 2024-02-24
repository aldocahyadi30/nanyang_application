class AttedanceLaborModel {
  final int attedanceId;
  final int employeeId;
  final String employeeName;
  final int workType;
  final int workStatus;
  final int qty;
  final double totalWeight;
  final double depreciationScore;
  final double cleanlinessScore;
  final double shapeScore;
  final DateTime date;

  AttedanceLaborModel({
    required this.attedanceId,
    required this.employeeId,
    required this.employeeName,
    required this.workType,
    required this.workStatus,
    required this.qty,
    required this.totalWeight,
    required this.depreciationScore,
    required this.cleanlinessScore,
    required this.shapeScore,
    required this.date,
  });

  static List<AttedanceLaborModel> fromSupabaseList(
      List<Map<String, dynamic>> attedances) {
    return attedances.map((attedance) {
      return AttedanceLaborModel(
          attedanceId: attedance['attedance_id'],
          employeeId: attedance['Employee']['employee_id'],
          employeeName: attedance['Employee']['name'],
          workType: attedance['AttedanceDetail']['work_type'],
          workStatus: attedance['AttedanceDetail']['work_status'],
          qty: attedance['AttedanceDetail']['qty'],
          totalWeight: attedance['AttedanceDetail']['total_weight'],
          depreciationScore: attedance['AttedanceDetail']['depreciation_score'],
          cleanlinessScore: attedance['AttedanceDetail']['cleanliness_score'],
          shapeScore: attedance['AttedanceDetail']['shape_score'],
          date: DateTime.parse(attedance['date']));
    }).toList();
  }
}
