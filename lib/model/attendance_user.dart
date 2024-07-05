import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_detail.dart';

class AttendanceUserModel {
  final DateTime date;
  final AttendanceModel? attendance;
  final AttendanceDetailModel? laborDetail;

  AttendanceUserModel({
    required this.date,
    required this.attendance,
    required this.laborDetail,
  });

  factory AttendanceUserModel.fromSupabase(List<Map<String, dynamic>> attendances, DateTime date) {
    AttendanceModel? attendance;
    AttendanceDetailModel? laborDetail;
    if (attendances[0]['absensi'].isNotEmpty) {
      List<dynamic> attendanceData = attendances[0]['absensi'];

      for (var i = 0; i < attendanceData.length; i++) {
        Map<String, dynamic> data = attendanceData[i];
        // Map<String, dynamic>? laborDetail;
        DateTime checkIn = DateTime.parse(data['waktu_masuk']);
        DateTime? checkOut;

        if (checkIn.year == date.year && checkIn.month == date.month && checkIn.day == date.day) {
          int inHour = checkIn.hour;
          int inStatus = 0;
          if (inHour < 12) {
            inStatus = 1;
          } else {
            inStatus = 2;
          }

          if (data['waktu_pulang'] != null) {
            checkOut = DateTime.parse(data['waktu_pulang']);
          }
          int outStatus = 0;
          if (checkOut != null) {
            outStatus = 1;
          }
          attendance = AttendanceModel(
            id: data['id_absensi'],
            checkIn: checkIn,
            checkOut: checkOut,
            inStatus: inStatus,
            outStatus: outStatus,
          );

          if (data['absensi_detail'].isNotEmpty) {
            // laborDetail = attendance['absensi_detail'][0]
            Map<String, dynamic> laborData = data['absensi_detail'][0];

            String status = '';
            if (data['absensi_detail'][0]['status'] == 1) {
              status = 'Memulai Tugas Baru';
            } else {
              status = 'Melanjutkan Tugas';
            }

            laborDetail = AttendanceDetailModel(
              id: laborData['id_detail'],
              status: laborData['status'].toInt(),
              statusName: status,
              featherType: laborData['status'] == 1 ? laborData['jenis_bulu'].toInt() : 0,
              initialQty: laborData['status'] == 1 ? laborData['qty_awal'].toInt() : 0,
              finalQty: laborData['status'] == 1 ? laborData['qty_akhir'].toInt() : 0,
              initialWeight: laborData['status'] == 1 ? laborData['berat_awal'].toDouble() : 0,
              finalWeight: laborData['status'] == 1 ? laborData['berat_akhir'].toDouble() : 0,
              minDepreciation: laborData['status'] == 1 ? laborData['min_susut'].toInt() : 0,
              performanceScore: laborData['status'] == 1 ? laborData['nilai_performa'].toDouble() : 0,
            );
          } else {
            laborDetail = AttendanceDetailModel.empty();
          }

          return AttendanceUserModel(
            date: date,
            attendance: attendance,
            laborDetail: laborDetail,
          );
        }
      }
    }
    return AttendanceUserModel(
      date: date,
      attendance: AttendanceModel.empty(),
      laborDetail: AttendanceDetailModel.empty(),
    );
  }

  static List<AttendanceUserModel> fromSupabaseList(List<Map<String, dynamic>> attendances, List<DateTime> dates) {
    return dates.map((date) {
      return AttendanceUserModel.fromSupabase(attendances, date);
    }).toList();
  }
}