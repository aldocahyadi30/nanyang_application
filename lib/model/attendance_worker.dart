class AttendanceWorkerModel {
  final int employeeId;
  final String employeeName;
  final int? attendanceId;
  final int? status;
  final int? type;
  final DateTime? checkIn;
  final DateTime? checkOut;

  AttendanceWorkerModel({
    this.attendanceId,
    required this.employeeId,
    required this.employeeName,
    this.status,
    this.type,
    this.checkIn,
    this.checkOut,
  });

  factory AttendanceWorkerModel.fromSupabase(Map<String, dynamic> attendance) {
    DateTime? checkIn;
    DateTime? checkOut;
    var status = 0;
    var attendanceValid = attendance['absensi'] is List && attendance['absensi'].isNotEmpty;

    if (attendanceValid && attendance['absensi'][0]['waktu_masuk'] != null) {
      var dateComponent = attendance['absensi'][0]['waktu_masuk'].split('T');
      var time = dateComponent[1].split(':');
      if (int.parse(time[0]) > 9) {
        status = 2;
      } else {
        status = 1;
      }

      checkIn = DateTime.parse(attendance['absensi'][0]['waktu_masuk']);
    }else{
      checkIn = null;
    }

    if (attendanceValid && attendance['absensi'][0]['waktu_keluar'] != null) {
      checkOut = DateTime.parse(attendance['absensi'][0]['waktu_keluar']);
    }else{
      checkOut = null;
    }

    return AttendanceWorkerModel(
      employeeId: attendance['id_karyawan'],
      employeeName: attendance['nama'],
      attendanceId: attendanceValid ? attendance['absensi'][0]['id_absensi'] : null,
      status: status != 0 ? status : null,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  static List<AttendanceWorkerModel> fromSupabaseList(List<Map<String, dynamic>> attendances) {
    return attendances.map((attendance) => AttendanceWorkerModel.fromSupabase(attendance)).toList();
  }
}