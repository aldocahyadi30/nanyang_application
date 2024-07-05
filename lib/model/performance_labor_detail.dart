class PerformanceLaborDetailModel{
  final DateTime date;
  final double performance;

  PerformanceLaborDetailModel({
    required this.date,
    required this.performance,
  });

  factory PerformanceLaborDetailModel.fromSupabase(Map<String, dynamic> detail){
    return PerformanceLaborDetailModel(
      date: DateTime.parse(detail['waktu_masuk']),
      performance: detail['absensi_detail'][0]['nilai_performa'].toDouble(),
    );
  }

  static List<PerformanceLaborDetailModel> fromSupabaseList(List<dynamic> details) {
    return details.map((detail) => PerformanceLaborDetailModel.fromSupabase(detail)).toList();
  }

  factory PerformanceLaborDetailModel.empty() {
    return PerformanceLaborDetailModel(
      date: DateTime.now(),
      performance: 0.0,
    );
  }
}