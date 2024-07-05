import 'package:nanyang_application/model/employee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getEmployee() async {
    try {
      final data = await supabase.from('karyawan').select('''
       *,
        posisi!inner(*)
      ''').order('nama', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<int>> getEmployeeCount() async {
    try {
      final worker =
          await supabase.from('karyawan').select('''id_karyawan, posisi!inner(tipe)''').eq('posisi.tipe', 1).count();
      final labor =
          await supabase.from('karyawan').select('''id_karyawan, posisi!inner(tipe)''').eq('posisi.tipe', 2).count();

      return [worker.count, labor.count];
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> store(EmployeeModel model) async {
    try {
      await supabase.from('karyawan').insert({
        'nama': model.name,
        'umur': model.age,
        'alamat': model.address,
        'tempat_lahir': model.birthPlace,
        'tanggal_lahir': model.birthDate?.toIso8601String(),
        'no_telp': model.phoneNumber,
        'gender': model.gender,
        'agama': model.religion,
        'id_mesin_absensi': model.attendanceMachineID,
        'tanggal_masuk': model.entryDate?.toIso8601String(),
        'gaji_pokok': model.salary,
        'id_posisi': model.position!.id,
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update(EmployeeModel model) async {
    try {
      await supabase.from('karyawan').update({
        'nama': model.name,
        'umur': model.age,
        'alamat': model.address,
        'tempat_lahir': model.birthPlace,
        'tanggal_lahir': model.birthDate,
        'no_telp': model.phoneNumber,
        'gender': model.gender,
        'agama': model.religion,
        'id_mesin_absensi': model.attendanceMachineID,
        'tanggal_masuk': model.entryDate?.toIso8601String(),
        'gaji_pokok': model.salary,
        'id_posisi': model.position.id,
      }).eq('id_karyawan', model.id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}