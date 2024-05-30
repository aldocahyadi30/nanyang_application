class EmployeeModel{
  final int id;
  final String name;
  final String shortedName;
  final String initials;
  final int age;
  final String? address;
  final int positionId;
  final String positionName;
  final int positionType;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.shortedName,
    required this.initials,
    required this.age,
    this.address,
    required this.positionId,
    required this.positionName,
    required this.positionType
  });

  factory EmployeeModel.fromSupabase(Map<String, dynamic> employee){

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

    initials = ((nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0][0] : '') +
            (nameParts.length > 1 && nameParts[1].isNotEmpty ? nameParts[1][0] : ''))
        .toUpperCase();
    return EmployeeModel(
      id: employee['id_karyawan'],
      name: employee['nama'],
      shortedName: shortedName,
      initials: initials,
      age: employee['umur'],
      address: employee['alamat'],
      positionId: employee['posisi']['id_posisi'],
      positionName: employee['posisi']['nama'],
      positionType: employee['posisi']['tipe']
    );
  }

  static List<EmployeeModel> fromSupabaseList(List<Map<String, dynamic>> employees){
    return employees.map((employee) => EmployeeModel.fromSupabase(employee)).toList();
  }
}