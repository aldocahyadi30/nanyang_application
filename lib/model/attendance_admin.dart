class AttendanceAdminModel {
  final int employeeId;
  final String employeeName;
  final String employeeShortName;
  final String employeeInitials;
  final int positionType;
  final Map<String, dynamic>? attendance;
  final Map<String, dynamic>? laborDetail;

  AttendanceAdminModel({
    required this.employeeId,
    required this.employeeName,
    required this.employeeShortName,
    required this.employeeInitials,
    required this.positionType,
    this.attendance,
    this.laborDetail,
  });

  factory AttendanceAdminModel.fromSupabase(Map<String, dynamic> attendanceData) {
    Map<String, dynamic> attendance = attendanceData['absensi'].isNotEmpty ? attendanceData['absensi'][0] : {};
    Map<String, dynamic>? laborDetail;
    DateTime? checkIn;
    DateTime? checkOut;
    int inStatus = 0;
    int outStatus = 0;
    String name = attendanceData['nama'];
    List<String> nameParts = name.split(' ');
    String shortedName = '';
    String initials = '';

    if (nameParts.length == 1) {
      shortedName = nameParts[0];
    } else if (nameParts.length == 2) {
      shortedName = nameParts.join(' ');
    } else {
      shortedName = nameParts.take(2).join(' ') + nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
    }

    initials =
        ((nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0][0] : '') + (nameParts.length > 1 && nameParts[1].isNotEmpty ? nameParts[1][0] : ''))
            .toUpperCase();

    if (attendance['waktu_pulang'] != null) {
      checkOut = DateTime.parse(attendance['waktu_pulang']);
      outStatus = 1;
    }

    if (attendance['waktu_masuk'] != null) {
      checkIn = DateTime.parse(attendance['waktu_masuk']);
      int inHour = checkIn.hour;
      if (inHour < 12) {
        inStatus = 1;
      } else {
        inStatus = 2;
      }
    }

    Map<String, dynamic> attendanceDetail = {
      'inStatus': inStatus,
      'outStatus': outStatus,
      'checkIn': checkIn,
      'checkOut': checkOut,
    };

    if (attendance.isNotEmpty && attendance['absensi_detail'].isNotEmpty) {
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
      } else {
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

    return AttendanceAdminModel(
      employeeId: attendanceData['id_karyawan'],
      employeeName: attendanceData['nama'],
      employeeShortName: shortedName,
      employeeInitials: initials,
      positionType: attendanceData['posisi']['tipe'],
      attendance: attendanceDetail,
      laborDetail: laborDetail,
    );
  }

  static List<AttendanceAdminModel> fromSupabaseList(List<Map<String, dynamic>> data) {
    List<AttendanceAdminModel> attendances = [];
    return data.map((attendance) => AttendanceAdminModel.fromSupabase(attendance)).toList();
  }
}
