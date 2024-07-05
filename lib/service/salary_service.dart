import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/salary.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalaryService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getEmployeeSalary(int employeeID, String period) async {
    try {
      final data = await supabase.from('gaji').select('*').eq('id_karyawan', employeeID).eq('periode', period);
      if (data.isEmpty) {
        return {};
      } else {
        return data[0];
      }
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeeList(String period) async {
    try {
      final data = await supabase.from('karyawan').select('''
        id_karyawan,
        nama,
        gaji_pokok,
        posisi!inner(*),
        gaji!left(*)
      ''').eq('gaji.periode', period).limit(1, referencedTable: 'gaji').order('nama', ascending: true);
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> getWorkerSalary(int employeeID, String startDate, String endDate) async {
    try {
      final data = await supabase.rpc('calculate_salary', params: {'emp_id': employeeID, 'start_date': startDate, 'end_date': endDate});
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> getLaborSalary(int employeeID, String startDate, String endDate) async {
    try {
      final data = await supabase.rpc('calculate_salary_labor', params: {'emp_id': employeeID, 'start_date': startDate, 'end_date': endDate});
      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> store(EmployeeModel employee, SalaryModel salary) async {
    try {
      await supabase.from('gaji').upsert([
        {
          'id_karyawan': employee.id,
          'periode': salary.period,
          'gaji': salary.baseSalary,
          'tunjangan': salary.totalBonus,
          'lembur': salary.totalOvertime,
          'bpjs': salary.bpjsRate,
          'potongan': salary.totalDeduction,
          'total_gaji': salary.totalSalary,
          'keterangan': salary.note,
          'jumlah_kehadiran': salary.totalAttendance,
          'jumlah_hari_kerja': salary.totalWorkingDay,
          'total_gram': salary.totalGram
        }
      ]);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update(EmployeeModel employee, SalaryModel salary) async {
    try {
      await supabase.from('gaji').update({
        'id_karyawan': employee.id,
        'periode': salary.period,
        'gaji': salary.baseSalary,
        'tunjangan': salary.totalBonus,
        'lembur': salary.totalOvertime,
        'bpjs': salary.bpjsRate,
        'potongan': salary.totalDeduction,
        'total_gaji': salary.totalSalary,
        'keterangan': salary.note,
        'jumlah_kehadiran': salary.totalAttendance,
        'jumlah_hari_kerja': salary.totalWorkingDay,
        'total_gram': salary.totalGram
      }).eq('id_gaji', salary.id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}