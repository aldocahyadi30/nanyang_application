import 'package:nanyang_application/model/request.dart';
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
          *,
          posisi(
            *
          )
        ),
        approver:id_approver(
          *,
          posisi(
            *
          )
        ),
        penolak:id_penolak(
          *,
          posisi(
            *
          )
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
          *,
          posisi(
            *
          )
        ),
        approver:id_approver(
          *,
          posisi(
            *
          )
        ),
        penolak:id_penolak(
          *,
          posisi(
            *
          )
        )
        ''');
      if (employeeID != null)query = query.eq('id_karyawan', employeeID);

      final data = await query.order('id_izin', ascending: false);

      return data;
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> store(RequestModel model) async {
    try {
      String path = '';
      if (model.file != null) {
        final String fileName = model.file!.path.split('/').last;
        path = await supabase.storage.from('request').upload(
              '/${model.requester.id}/$fileName',
              model.file!,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
      }
      await supabase.from('izin').insert({
        'id_karyawan': model.requester.id,
        'jenis': model.type,
        'waktu_mulai': model.startDateTime?.toIso8601String(),
        'waktu_akhir': model.endDateTime?.toIso8601String(),
        'alasan': model.reason,
        'file': path,
        'update_oleh': model.requester.id,
      });
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update(RequestModel model) async {
    try {
      String path = '';
      if (model.file != null) {
        final String fileName = model.file!.path.split('/').last;
        path = await supabase.storage.from('request').upload(
             '/${model.requester.id}/$fileName',
              model.file!,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );

        await supabase.from('izin').update({
          'jenis': model.type,
          'waktu_mulai': model.startDateTime?.toIso8601String(),
          'waktu_akhir': model.endDateTime?.toIso8601String(),
          'alasan': model.reason,
          'file': path,
          'update_oleh': model.requester.id,
        }).eq('id_izin', model.id);
      } else {
        await supabase.from('izin').update({
          'jenis': model.type,
          'waktu_mulai': model.startDateTime?.toIso8601String(),
          'waktu_akhir': model.endDateTime?.toIso8601String(),
          'alasan': model.reason,
          'update_oleh': model.requester.id,
        }).eq('id_izin', model.id);
      }
    } on PostgrestException catch (error) {
      throw PostgrestException(message: error.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> delete(int id) async{
    try {
      supabase.from('izin').delete().eq('id_izin', id);
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