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

  static List<AttendanceLaborModel> fromSupabaseList(List<Map<String, dynamic>> attendances) {
    return attendances.map((attendance) => AttendanceLaborModel.fromSupabase(attendance)).toList();
  }

  factory AttendanceLaborModel.fromSupabase(Map<String, dynamic> attendance) {
    var attendanceValid = attendance['absensi'] is List && attendance['absensi'].isNotEmpty;

    var detailValid = attendanceValid &&
        attendance['absensi'][0]['absensi_detail'] is List &&
        attendance['absensi'][0]['absensi_detail'].isNotEmpty;

    var status = 0;
    if (detailValid) {
      var temp = attendance['absensi'][0]['absensi_detail'][0]['status_pekerjaan'];
      if (temp == 'tugasBaru') {
        status = 1;
      } else if (temp == 'tugasLanjut') {
        status = 2;
      } else if (temp == 'tidakHadir') {
        status = 3;
      }
    }
    return AttendanceLaborModel(
        attendanceId: attendanceValid ? attendance['absensi'][0]['id_absensi'] : null,
        employeeId: attendance['id_karyawan'],
        employeeName: attendance['nama'],
        type: detailValid ? attendance['absensi'][0]['absensi_detail'][0]['jenis_pekerjaan'] : null,
        status: status,
        initialQty: detailValid ? attendance['absensi'][0]['absensi_detail'][0]['qty_awal'] : null,
        finalQty: detailValid ? attendance['absensi'][0]['absensi_detail'][0]['qty_akhir'] : null,
        initialWeight:
            detailValid ? attendance['absensi'][0]['absensi_detail'][0]['berat_awal'].toDouble() : null,
        finalWeight: detailValid ? attendance['absensi'][0]['absensi_detail'][0]['berat_akhir'].toDouble() : null
    );
  }
}