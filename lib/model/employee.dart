class EmployeeModel {
  final int id;
  final String name;
  final String shortedName;
  final String initials;
  final int? age;
  final String? address;
  final int positionId;
  final String positionName;
  final int positionType;
  final String? birthPlace;
  final DateTime? birthDate;
  final String? phoneNumber;
  final String? gender;
  final String? religion;
  final int? attendanceMachineID;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.shortedName,
    required this.initials,
    this.age,
    this.address,
    required this.positionId,
    required this.positionName,
    required this.positionType,
    this.birthPlace,
    this.birthDate,
    this.phoneNumber,
    this.gender,
    this.religion,
    this.attendanceMachineID,
  });

  factory EmployeeModel.fromSupabase(Map<String, dynamic> employee) {
    String name = employee['nama'];
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
    return EmployeeModel(
      id: employee['id_karyawan'],
      name: name,
      shortedName: shortedName,
      initials: initials,
      age: employee['umur'],
      address: employee['alamat'],
      positionId: employee['posisi']['id_posisi'],
      positionName: employee['posisi']['nama'],
      positionType: employee['posisi']['tipe'],
      birthPlace: employee['tempat_lahir'],
      birthDate: employee['tanggal_lahir'] != null ? DateTime.parse(employee['tanggal_lahir']) : null,
      phoneNumber: employee['no_hp'],
      gender: employee['gender'],
      religion: employee['agama'],
      attendanceMachineID: employee['id_mesin_absensi'],
    );
  }

  static List<EmployeeModel> fromSupabaseList(List<Map<String, dynamic>> employees) {
    return employees.map((employee) => EmployeeModel.fromSupabase(employee)).toList();
  }
}
