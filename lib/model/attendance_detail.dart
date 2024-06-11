class AttendanceDetailModel{
  int id;
  int status;
  String? statusName;
  int? featherType;
  int? initialQty;
  int? finalQty;
  double? initialWeight;
  double? finalWeight;
  int? minDepreciation;
  double? performanceScore;

  AttendanceDetailModel({
    required this.id,
    required this.status,
    this.statusName,
    this.featherType,
    this.initialQty,
    this.finalQty,
    this.initialWeight,
    this.finalWeight,
    this.minDepreciation,
    this.performanceScore,
  });

  factory AttendanceDetailModel.empty() {
    return AttendanceDetailModel(
      id: 0,
      status: 0,
    );
  }
}