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
    this.initialQty = 0,
    this.finalQty = 0,
    this.initialWeight = 0,
    this.finalWeight = 0,
    this.minDepreciation = 0,
    this.performanceScore = 0,
  });

  factory AttendanceDetailModel.empty() {
    return AttendanceDetailModel(
      id: 0,
      status: 0,
    );
  }
}