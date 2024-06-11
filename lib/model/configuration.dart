class ConfigurationModel {
  double foodAllowanceWorker;
  double foodAllowanceLabor;
  int cutoffDay;

  ConfigurationModel({
    required this.foodAllowanceWorker,
    required this.foodAllowanceLabor,
    required this.cutoffDay,
  });

  factory ConfigurationModel.fromMap(List<Map<String, dynamic>> configurations) {
    return ConfigurationModel(
      foodAllowanceWorker: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'uang_makan_karyawan').first['value']),
      foodAllowanceLabor: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'uang_makan_cabutan').first['value']),
      cutoffDay: int.parse(configurations.where((element) => element['nama_konfigurasi'] == 'tanggal_cutoff').first['value']),
    );
  }

  factory ConfigurationModel.empty() {
    return ConfigurationModel(
      foodAllowanceWorker: 0,
      foodAllowanceLabor: 0,
      cutoffDay: 0,
    );
  }
}
