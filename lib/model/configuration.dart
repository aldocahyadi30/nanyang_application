class ConfigurationModel {
  double foodAllowanceWorker;
  double foodAllowanceLabor;
  double laborBaseSalary;
  double peformanceThreshold;
  double overtimeBaseSalary;
  int cutoffDay;

  ConfigurationModel({
    required this.foodAllowanceWorker,
    required this.foodAllowanceLabor,
    required this.laborBaseSalary,
    required this.peformanceThreshold,
    required this.overtimeBaseSalary,
    required this.cutoffDay,
  });

  factory ConfigurationModel.fromSupabaseList(List<Map<String, dynamic>> configurations) {
    return ConfigurationModel(
      foodAllowanceWorker: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'uang_makan_karyawan').first['value']),
      foodAllowanceLabor: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'uang_makan_cabutan').first['value']),
      laborBaseSalary: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'gaji_produksi_gram').first['value']),
      peformanceThreshold: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'batas_performa').first['value']),
      overtimeBaseSalary: double.parse(configurations.where((element) => element['nama_konfigurasi'] == 'uang_lembur').first['value']),
      cutoffDay: int.parse(configurations.where((element) => element['nama_konfigurasi'] == 'tanggal_cutoff').first['value']),
    );
  }

  factory ConfigurationModel.empty() {
    return ConfigurationModel(
      foodAllowanceWorker: 0,
      foodAllowanceLabor: 0,
      laborBaseSalary: 0,
      peformanceThreshold: 0,
      overtimeBaseSalary: 0,
      cutoffDay: 0,
    );
  }
}