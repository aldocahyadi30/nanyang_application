import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
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

      final data = await Supabase.instance.client.from('karyawan').select('''
          *,
          posisi!inner(*),
          absensi!left(*, absensi_detail(*))
          ''').eq('posisi.tipe', type).gte('absensi.waktu_masuk', startTime).lte('absensi.waktu_masuk', endTime).limit(1, referencedTable: 'absensi').order('nama', ascending: true);

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
          id_karyawan,
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

  Future<AttendanceLaborModel> getLaborAttendanceByID(int id) async {
    try {
      final attendance = await supabase.from('karyawan').select('''
          *,
          posisi!inner(*),
          absensi!left(*, absensi_detail(*))
          ''').eq('id_karyawan', id).single();

      return AttendanceLaborModel.fromSupabase(attendance);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> storeLaborAttendance(AttendanceLaborModel model, String date, String status, int type, int? initialQty, int? finalQty, double? initialWeight,
      double? finalWeight, int? cleanScore) async {
    try {
      double weightScore = (1 - (finalWeight! / initialWeight!)) * 100;
      double qtyScore = (finalQty! / initialQty!) * 100;
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      DateTime now = DateTime.now();
      DateTime currentDateTime = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, now.hour, now.minute, now.second);
      String parsedCurrentDate = currentDateTime.toIso8601String();

      final List<Map<String, dynamic>> attendance =
          await supabase.from('absensi').insert({'waktu_masuk': parsedCurrentDate, 'id_karyawan': model.employeeId}).select();

      List<Map<String, dynamic>> detail = await supabase.from('absensi_detail').insert({
        'id_absensi': attendance[0]['id_absensi'],
        'jenis_pekerjaan': type,
        'status_pekerjaan': status,
        'qty_awal': initialQty,
        'qty_akhir': finalQty,
        'berat_awal': initialWeight,
        'berat_akhir': finalWeight
      }).select('id_detail');

      await supabase.from('performa_harian').insert({
        'id_detail': detail[0]['id_detail'],
        'nilai_kebersihan': cleanScore,
        'nilai_depresiasi': weightScore,
        'nilai_bentuk': qtyScore,
        'nilai_performa': 0
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
