import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestService {
  SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getDashboardRequest(int userLevel, {int? employeeID}) async {
    try {
      var query = supabase.from('izin').select('''
        id_izin,
        jenis,
        status,
        waktu_mulai,
        waktu_akhir,
        alasan,
        komentar,
        waktu_approve,
        waktu_tolak,
        file,
        karyawan:id_karyawan(
          id_karyawan,
          nama
        ),
        approver:id_approver(
          id_karyawan,
          nama
        ),
        penolak:id_penolak(
          id_karyawan,
          nama
        )
        ''');

      if (userLevel > 1) query = query.eq('status', 0);

      if (employeeID != null) query = query.eq('id_karyawan', employeeID);

      final data = await query.order('id_izin', ascending: false).limit(3);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getListRequest({int? employeeID}) async {
    try {
      final query = supabase.from('izin').select('''
        id_izin,
        jenis,
        status,
        waktu_mulai,
        waktu_akhir,
        alasan,
        komentar,
        waktu_approve,
        waktu_tolak,
        file,
        karyawan:id_karyawan(
          id_karyawan,
          nama
        ),
        approver:id_approver(
          id_karyawan,
          nama
        ),
        penolak:id_penolak(
          id_karyawan,
          nama
        )
        ''');

      if (employeeID != null) query.eq('id_karyawan', employeeID);

      final data = await query.order('id_izin', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getListRequestByID(int employeeID) async {
    try {
      final data = await supabase.from('izin').select('''
        id_izin,
        jenis,
        status,
        waktu_mulai,
        waktu_akhir,
        alasan,
        komentar,
        waktu_approve,
        waktu_tolak,
        file,
        karyawan:id_karyawan(
          id_karyawan,
          nama
        ),
        approver:id_approver(
          id_karyawan,
          nama
        ),
        penolak:id_penolak(
          id_karyawan,
          nama
        )
        ''').eq('id_karyawan', employeeID).order('id_izin', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> store(int employeeID, int type, String reason, {File? file, String? startTime, String? endTime}) async {
    try {
      String path = '';
      if (file != null) {
        final String fileName = file.path.split('/').last;
        path = await supabase.storage.from('RequestFile').upload(
              '/$employeeID/$fileName',
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      }
      await supabase.from('izin').insert({
        'id_karyawan': employeeID,
        'jenis': type,
        'waktu_mulai': startTime,
        'waktu_akhir': endTime,
        'alasan': reason,
        'file': path,
        'update_oleh': employeeID,
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update(int id, int employeeID, int type, String reason, {File? file, String? startTime, String? endTime}) async {
    try {
      String path = '';
      if (file != null) {
        final String fileName = file.path.split('/').last;
        path = await supabase.storage.from('RequestFile').upload(
              '/$employeeID/$fileName',
              file,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );

        await supabase.from('izin').update({
          'id_karyawan': employeeID,
          'jenis': type,
          'waktu_mulai': startTime,
          'waktu_akhir': endTime,
          'alasan': reason,
          'file': path,
          'update_oleh': employeeID,
        }).eq('id_izin', id);
      } else {
        await supabase.from('izin').update({
          'id_karyawan': employeeID,
          'jenis': type,
          'waktu_mulai': startTime,
          'waktu_akhir': endTime,
          'alasan': reason,
          'update_oleh': employeeID,
        }).eq('id_izin', id);
      }
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> approve(int id, int employeeID, String? comment) async {
    try {
      await supabase.from('izin').update({
        'id_approver': employeeID,
        'komentar': comment,
        'status': 1,
        'waktu_approve': DateTime.now().toIso8601String(),
        'update_oleh': employeeID,
      }).eq('id_izin', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> reject(int id, int employeeID, String comment) async {
    try {
      await supabase.from('izin').update({
        'id_penolak': employeeID,
        'komentar': comment,
        'status': 2,
        'waktu_tolak': DateTime.now().toIso8601String(),
        'update_oleh': employeeID,
      }).eq('id_izin', id);
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
