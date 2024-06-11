import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_detail.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/position.dart';

class AttendanceAdminModel {
  EmployeeModel employee;
  AttendanceModel? attendance;
  AttendanceDetailModel? laborDetail;

  AttendanceAdminModel({
    required this.employee,
    this.attendance,
    this.laborDetail,
  });

  factory AttendanceAdminModel.fromSupabase(Map<String, dynamic> attendanceData) {
    EmployeeModel employee;
    AttendanceModel? attendance;
    AttendanceDetailModel? laborDetail;
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

    employee = EmployeeModel(
      id: attendanceData['id_karyawan'],
      name: name,
      shortedName: shortedName,
      initials: initials,
      position: PositionModel(
        id: attendanceData['posisi']['id_posisi'],
        name: attendanceData['posisi']['nama'],
        type: attendanceData['posisi']['tipe'],
      ),
    );
    if (attendanceData['absensi'].isNotEmpty) {
      Map<String, dynamic> data = attendanceData['absensi'][0];
      DateTime? checkIn;
      DateTime? checkOut;
      int inStatus = 0;
      int outStatus = 0;
      if (data['waktu_pulang'] != null) {
        checkOut = DateTime.parse(data['waktu_pulang']);
        outStatus = 1;
      }

      if (data['waktu_masuk'] != null) {
        checkIn = DateTime.parse(data['waktu_masuk']);
        int inHour = checkIn.hour;
        if (inHour < 12) {
          inStatus = 1;
        } else {
          inStatus = 2;
        }
      }

      attendance = AttendanceModel(
        id: data['id_absensi'],
        checkIn: checkIn,
        checkOut: checkOut,
        inStatus: inStatus,
        outStatus: outStatus,
      );
    } else {
      attendance = AttendanceModel.empty();
    }

    if (attendance.id != 0 && attendanceData['absensi'][0]['absensi_detail'].isNotEmpty) {
      // laborDetail = attendance['absensi_detail'][0]
      Map<String, dynamic> laborData = attendanceData['absensi'][0]['absensi_detail'][0];

      String status = '';
      if (laborData['status'] == 1) {
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
    } else {
      laborDetail = AttendanceDetailModel.empty();
    }

    return AttendanceAdminModel(
      employee: employee,
      attendance: attendance,
      laborDetail: laborDetail,
    );
  }

  static List<AttendanceAdminModel> fromSupabaseList(List<Map<String, dynamic>> data) {
    return data.map((attendance) => AttendanceAdminModel.fromSupabase(attendance)).toList();
  }

  factory AttendanceAdminModel.empty() {
    return AttendanceAdminModel(
      employee: EmployeeModel.empty(),
      attendance: AttendanceModel.empty(),
      laborDetail: AttendanceDetailModel.empty(),
    );
  }
}
