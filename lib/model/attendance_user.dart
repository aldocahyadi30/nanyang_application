import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_detail.dart';

class AttendanceUserModel {
  final DateTime date;
  final AttendanceModel? attendance;
  final AttendanceDetailModel? laborDetail;

  AttendanceUserModel({
    required this.date,
    // this.attendance,
    // this.laborDetail,
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

        if (data['waktu_pulang'] != null) {
          checkOut = DateTime.parse(data['waktu_pulang']);
        }

        if (checkIn.year == date.year && checkIn.month == date.month && checkIn.day == date.day) {
          int inHour = checkIn.hour;
          int inStatus = 0;
          if (inHour < 12) {
            inStatus = 1;
          } else {
            inStatus = 2;
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
            Map<String, dynamic> laborData = attendanceData[0]['absensi_detail'][0];


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
              featherType: laborData['jenis_bulu'].toInt(),
              initialQty: laborData['qty_awal'].toInt(),
              finalQty: laborData['qty_akhir'].toInt(),
              initialWeight: laborData['berat_awal'].toDouble(),
              finalWeight: laborData['berat_akhir'].toDouble(),
              minDepreciation: laborData['min_susut'].toInt(),
              performanceScore: laborData['nilai_performa'].toDouble(),
            );
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
