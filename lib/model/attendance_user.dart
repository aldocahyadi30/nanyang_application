class AttendanceUserModel {
  final DateTime date;
  final Map<String, dynamic>? attendance;
  final Map<String, dynamic>? laborDetail;

  AttendanceUserModel({
    required this.date,
    this.attendance,
    this.laborDetail,
  });

  factory AttendanceUserModel.fromSupabase(List<Map<String, dynamic>> attendances, DateTime date) {
    if (attendances[0]['absensi'].isNotEmpty) {
      List<dynamic> data = attendances[0]['absensi'];

      for (var i = 0; i < data.length; i++) {
        Map<String, dynamic> attendance = data[i];
        Map<String, dynamic>? laborDetail;
        DateTime checkIn = DateTime.parse(attendance['waktu_masuk']);
        DateTime? checkOut;

        if (attendance['waktu_pulang'] != null) {
          checkOut = DateTime.parse(attendance['waktu_pulang']);
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

          Map<String, dynamic> attendanceDetail = {
            'inStatus': inStatus,
            'outStatus': outStatus,
            'checkIn': checkIn,
            'checkOut': checkOut,
          };

          if (attendance['absensi_detail'].isNotEmpty) {
            // laborDetail = attendance['absensi_detail'][0]
            String type = '';
            if (attendance['absensi_detail'][0]['tipe_pekerjaan'] == 1) {
              type = 'Cabut Sarang';
            } else {
              type = 'Bentuk Sarang';
            }

            String status = '';
            if (attendance['absensi_detail'][0]['status_pekerjaan'] == 'tugasBaru') {
              status = 'Memulai Tugas Baru';
            } else if (attendance['absensi_detail'][0]['status_pekerjaan'] == 'tugasLanjut') {
              status = 'Melanjutkan Tugas';
            } else{
              status = 'Tidak Hadir';
            }

            laborDetail = {
              'type': type,
              'status': status,
              'initialQty': attendance['absensi_detail'][0]['jumlah_awal'],
              'finalQty': attendance['absensi_detail'][0]['jumlah_akhir'],
              'initialWeight': attendance['absensi_detail'][0]['berat_awal'],
              'finalWeight': attendance['absensi_detail'][0]['berat_akhir'],
              'cleanScore': attendance['absensi_detail'][0]['nilai_kebersihan'],
            };
          }

          return AttendanceUserModel(
            date: date,
            attendance: attendanceDetail,
            laborDetail: laborDetail,
          );
        }
      }
    }
    return AttendanceUserModel(
      date: date,
      attendance: {
        'inStatus': 0,
        'outStatus': 0,
        'checkIn': null,
        'checkOut': null,
      },
      laborDetail: null,
    );
  }

  static List<AttendanceUserModel> fromSupabaseList(List<Map<String, dynamic>> attendances, List<DateTime> dates) {
    return dates.map((date) {
      return AttendanceUserModel.fromSupabase(attendances, date);
    }).toList();
  }
}