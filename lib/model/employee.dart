import 'dart:math';

import 'package:nanyang_application/model/position.dart';
import 'package:nanyang_application/model/salary.dart';

class EmployeeModel {
  final int id;
  String name;
  String? shortedName;
  String? initials;
  int? age;
  String? address;
  String? birthPlace;
  DateTime? birthDate;
  String? phoneNumber;
  String? gender;
  String? religion;
  int? attendanceMachineID;
  DateTime? entryDate;
  double? salary;
  PositionModel position;
  SalaryModel? thisMonthSalary;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.shortedName,
    required this.initials,
    this.age,
    this.address = '',
    this.birthPlace,
    this.birthDate,
    this.phoneNumber = '',
    this.gender = '',
    this.religion = '',
    this.attendanceMachineID = 0,
    this.entryDate,
    this.salary = 0.0,
    required this.position,
    this.thisMonthSalary,
  });

  factory EmployeeModel.fromSupabase(Map<String, dynamic> employee) {
    SalaryModel? thisMonthSalary;
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

    if (employee['gaji'] != null && employee['gaji'].isNotEmpty) {
      thisMonthSalary = SalaryModel.fromMap(employee['gaji']);
    }
    return EmployeeModel(
      id: employee['id_karyawan'],
      name: name,
      shortedName: shortedName,
      initials: initials,
      age: employee['umur'],
      address: employee['alamat'],
      position: PositionModel.fromSupabase(employee['posisi']),
      thisMonthSalary: thisMonthSalary,
      birthPlace: employee['tempat_lahir'],
      birthDate: employee['tanggal_lahir'] != null ? DateTime.parse(employee['tanggal_lahir']) : null,
      entryDate: employee['tanggal_masuk'] != null ? DateTime.parse(employee['tanggal_masuk']) : null,
      phoneNumber: employee['no_telp'].toString(),
      gender: employee['gender'].toString(),
      religion: employee['agama'].toString(),
      salary: employee['gaji_pokok'] != null ? employee['gaji_pokok'].toDouble() : 0.0,
      attendanceMachineID: employee['id_mesin_absensi'],
    );
  }

  static List<EmployeeModel> fromSupabaseList(List<Map<String, dynamic>> employees) {
    return employees.map((employee) => EmployeeModel.fromSupabase(employee)).toList();
  }

  factory EmployeeModel.empty() {
    return EmployeeModel(
      id: 0,
      name: '',
      shortedName: '',
      initials: '',
      position: PositionModel.empty(),
    );
  }

  EmployeeModel copyWith({
    int? id,
    String? name,
    String? shortedName,
    String? initials,
    int? age,
    String? address,
    String? birthPlace,
    DateTime? birthDate,
    String? phoneNumber,
    String? gender,
    String? religion,
    int? attendanceMachineID,
    DateTime? entryDate,
    double? salary,
    PositionModel? position,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortedName: shortedName ?? this.shortedName,
      initials: initials ?? this.initials,
      age: age ?? this.age,
      address: address ?? this.address,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      attendanceMachineID: attendanceMachineID ?? this.attendanceMachineID,
      entryDate: entryDate ?? this.entryDate,
      salary: salary ?? this.salary,
      position: position ?? this.position,
    );
  }
}
