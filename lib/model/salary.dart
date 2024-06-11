class SalaryModel {
  int id;
  int employeeId;
  double monthlySalary;
  double totalSalary;
  double bpjsRate;
  double totalOvertime;
  double totalDeduction;
  double totalBonus;
  String period;
  int totalAttendance;
  int totalWorkingDay;
  String note;
  bool isSaved;

  SalaryModel({
    required this.id,
    required this.employeeId,
    this.monthlySalary = 0,
    this.totalSalary = 0,
    this.bpjsRate = 0,
    this.totalOvertime = 0,
    this.totalDeduction = 0,
    this.totalBonus = 0,
    required this.period,
    this.totalAttendance = 0,
    this.totalWorkingDay = 0,
    this.note = '',
    this.isSaved = false,
  });

  factory SalaryModel.fromMap(Map<String, dynamic> salary) {
    return SalaryModel(
      id: salary['id_gaji'],
      employeeId: salary['id_karyawan'],
      monthlySalary: salary['gaji'].toDouble() ?? 0,
      totalSalary: salary['total_gaji'].toDouble() ?? 0,
      bpjsRate: salary['bpjs'].toDouble() ?? 0,
      totalOvertime: salary['lembur'].toDouble() ?? 0,
      totalDeduction: salary['potongan'].toDouble() ?? 0,
      totalBonus: salary['tunjangan'].toDouble() ?? 0,
      period: salary['periode'],
      totalAttendance: salary['jumlah_kehadiran'] ?? 0,
      totalWorkingDay: salary['jumlah_hari_kerja'] ?? 0,
      note: salary['keterangan'] ?? '',
      isSaved: true,
    );
  }

  factory SalaryModel.fromFunction(List<dynamic> salary, String period, int employeeId) {
    return SalaryModel(
      id: 0,
      employeeId: employeeId,
      monthlySalary: salary[0]['monthly_wage'].toDouble(),
      totalSalary: salary[0]['total_salary'].toDouble(),
      totalOvertime: salary[0]['total_overtime'].toDouble(),
      totalDeduction: salary[0]['total_cut'].toDouble(),
      totalBonus: 0,
      period: period,
      totalAttendance: salary[0]['total_attendance'],
      totalWorkingDay: salary[0]['total_working'],
      isSaved: false,
    );
  }

  static List<SalaryModel> fromMapList(List<Map<String, dynamic>> salaries) {
    return salaries.map((salary) => SalaryModel.fromMap(salary)).toList();
  }

  factory SalaryModel.empty() {
    return SalaryModel(
      id: 0,
      employeeId: 0,
      monthlySalary: 0,
      totalSalary: 0,
      bpjsRate: 0,
      totalOvertime: 0,
      totalDeduction: 0,
      totalBonus: 0,
      period: '',
      totalAttendance: 0,
      totalWorkingDay: 0,
    );
  }

  factory SalaryModel.copyWith(SalaryModel salary, {int? id, int? employeeId, double? monthlySalary, double? totalSalary, double? bpjsRate, double? totalOvertime, double? totalDeduction, double? totalBonus, String? period, int? totalAttendance, int? totalWorkingDay, String? note, bool? isSaved}) {
    return SalaryModel(
      id: id ?? salary.id,
      employeeId: employeeId ?? salary.employeeId,
      monthlySalary: monthlySalary ?? salary.monthlySalary,
      totalSalary: totalSalary ?? salary.totalSalary,
      bpjsRate: bpjsRate ?? salary.bpjsRate,
      totalOvertime: totalOvertime ?? salary.totalOvertime,
      totalDeduction: totalDeduction ?? salary.totalDeduction,
      totalBonus: totalBonus ?? salary.totalBonus,
      period: period ?? salary.period,
      totalAttendance: totalAttendance ?? salary.totalAttendance,
      totalWorkingDay: totalWorkingDay ?? salary.totalWorkingDay,
      note: note ?? salary.note,
      isSaved: isSaved ?? salary.isSaved,
    );
  }
}
