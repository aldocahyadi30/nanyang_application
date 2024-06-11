import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getWorkerAttendanceByDate(String date) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final data = await Supabase.instance.client.from('karyawan').select('''
          *,
          posisi!inner(*),
          absensi!left(*)
          ''').eq('posisi.tipe', 1).gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).order('nama', ascending: true);
      return data;
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getLaborAttendanceByDate(String date) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final data = await Supabase.instance.client.from('karyawan').select('''
          *,
          posisi!inner(*),
          absensi!left(*, absensi_detail(*))
          ''').eq('posisi.tipe', 2).gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).order('nama', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAdminAttendanceByDate(String date, int type) async {
    try {
      final startTime = '$date 01:00:00';
      final endTime = '$date 23:59:59';

      final data = await Supabase.instance.client
          .from('karyawan')
          .select('''
          *,
          posisi!inner(*),
          absensi!left(*, absensi_detail(*))
          ''')
          .eq('posisi.tipe', type)
          .gte('absensi.waktu_masuk', startTime)
          .lte('absensi.waktu_masuk', endTime)
          .limit(1, referencedTable: 'absensi')
          .order('nama', ascending: true);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getUserAttendance(int employeeID, String startDate, String endDate) async {
    try {
      final startTime = '$startDate 01:00:00';
      final endTime = '$endDate 23:59:59';

      final data = await supabase.from('karyawan').select('''
          *,
          absensi!left(*, absensi_detail!left(*))
          ''').gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).eq('id_karyawan', employeeID);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<int>> getAttendanceCount() async {
    try {
      String startTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
      startTime = '$startTime 01:00:00';
      String endTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endTime = '$endTime 23:59:59';

      final worker = await supabase.from('karyawan').select('''
          id_karyawan,
          posisi!inner(tipe),
          absensi!inner(waktu_masuk)
          ''').eq('posisi.tipe', 1).gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).count();

      final labor = await supabase.from('karyawan').select('''
          id_karyawan,
          posisi!inner(tipe),
          absensi!inner(waktu_masuk, absensi_detail!inner(id_detail))
          ''').eq('posisi.tipe', 2).gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).count();

      return [worker.count, labor.count];
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> storeWorkerAttendance(AttendanceAdminModel model) async {
    try {
      if (model.attendance!.id != 0) {
        await supabase
            .from('absensi')
            .update({'waktu_masuk': model.attendance!.checkIn!.toIso8601String(), 'waktu_keluar': model.attendance!.checkOut!.toIso8601String()})
            .eq('id_absensi', model.attendance!.id)
            .eq('id_karyawan', model.employee.id);
      } else {
        await supabase.from('absensi').insert({
          'waktu_masuk': model.attendance!.checkIn!.toIso8601String(),
          'waktu_keluar': model.attendance!.checkOut!.toIso8601String(),
          'id_karyawan': model.employee.id
        });
      }
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<void> storeLaborAttendance(AttendanceAdminModel model) async {
    try {
      final List<Map<String, dynamic>> attendance =
          await supabase.from('absensi').insert({'waktu_masuk': model.attendance!.checkIn!.toIso8601String(), 'id_karyawan': model.employee.id}).select();

      await supabase.from('absensi_detail').insert({
        'id_absensi': attendance[0]['id_absensi'],
        'jenis_bulu': model.laborDetail!.featherType,
        'status': model.laborDetail!.status,
        'qty_awal': model.laborDetail!.initialQty,
        'qty_akhir': model.laborDetail!.finalQty,
        'berat_awal': model.laborDetail!.initialWeight,
        'berat_akhir': model.laborDetail!.finalWeight,
        'min_susut': model.laborDetail!.minDepreciation,
        'nilai_performa': model.laborDetail!.performanceScore
      });
    } on PostgrestException catch (error) {
      debugPrint('Attendance error: ${error.message}');
      throw PostgrestException(message: error.message);
    } catch (e) {
      debugPrint('Attendance error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
