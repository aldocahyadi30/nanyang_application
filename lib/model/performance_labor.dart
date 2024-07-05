import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/performance_labor_detail.dart';
import 'package:nanyang_application/model/position.dart';

class PerformanceLaborModel{
  final EmployeeModel employee;
  double avgPerformance;
  List<PerformanceLaborDetailModel> performanceLaborDetail;

  PerformanceLaborModel({
    required this.employee,
    this.avgPerformance = 0,
    required this.performanceLaborDetail,
  });

  factory PerformanceLaborModel.fromSupabase(Map<String, dynamic> performanceLabor){
    String name = performanceLabor['nama'];
    List<String> nameParts = name.split(' ');
    String shortedName = '';
    String initials = '';
    double total = 0;
    int count = 0;

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

    for (var detail in performanceLabor['absensi']){
      if (detail['absensi_detail'][0]['nilai_performa'] != null && detail['absensi_detail'][0]['nilai_performa'] != 0){
        total += detail['absensi_detail'][0]['nilai_performa'];
        count++;
      }
    }
    return PerformanceLaborModel(
      employee: EmployeeModel(
        id: performanceLabor['id_karyawan'],
        name: name,
        shortedName: shortedName,
        initials: initials,
        position: PositionModel(
          id: performanceLabor['posisi']['id_posisi'],
          name: performanceLabor['posisi']['nama'],
          type: performanceLabor['posisi']['tipe'],
        ),
      ),
      avgPerformance: count > 0 ? total/count : 0,
      performanceLaborDetail: PerformanceLaborDetailModel.fromSupabaseList(performanceLabor['absensi']),
    );
  }

  static List<PerformanceLaborModel> fromSupabaseList(List<Map<String, dynamic>> performanceLabors) {
    return performanceLabors.map((performanceLabor) => PerformanceLaborModel.fromSupabase(performanceLabor)).toList();
  }
}