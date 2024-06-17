import 'dart:io';

import 'package:nanyang_application/model/employee.dart';

class RequestModel {
  final int id;
  int type;
  int status;
  DateTime? startDateTime;
  DateTime? endDateTime;
  DateTime? approvalTime;
  DateTime? rejectTime;
  String? reason;
  String? comment;
  String? filePath;
  File? file;
  EmployeeModel requester;
  EmployeeModel? approver;
  EmployeeModel? rejecter;

  RequestModel({
    required this.id,
    required this.type,
    required this.status,
    this.startDateTime,
    this.endDateTime,
    this.approvalTime,
    this.rejectTime,
    this.reason,
    this.comment,
    this.filePath,
    this.file,
    required this.requester,
    this.approver,
    this.rejecter,
  });


factory RequestModel.fromSupabase(Map<String, dynamic> request) {
    bool haveApprover = request['approver'] != null;
    bool haveRejecter = request['penolak'] != null;
    EmployeeModel approver;
    EmployeeModel rejecter;

    if (haveApprover) {
      approver = EmployeeModel.fromSupabase(request['approver']);
    } else {
      approver = EmployeeModel.empty();
    }

    if (haveRejecter) {
      rejecter = EmployeeModel.fromSupabase(request['penolak']);
    } else {
      rejecter = EmployeeModel.empty();
    }

    return RequestModel(
      id: request['id_izin'],
      type: request['jenis'],
      status: request['status'],
      startDateTime: request['waktu_mulai'] == null ? null : DateTime.tryParse(request['waktu_mulai']),
      endDateTime: request['waktu_akhir'] == null ? null : DateTime.tryParse(request['waktu_akhir']),
      approvalTime: request['waktu_approve'] == null ? null : DateTime.tryParse(request['waktu_approve']),
      rejectTime: request['waktu_tolak'] == null ? null : DateTime.tryParse(request['waktu_tolak']),
      requester: EmployeeModel.fromSupabase(request['karyawan']),
      approver: approver,
      rejecter: rejecter,
      reason: request['alasan'] ?? '',
      comment: haveRejecter || haveApprover ? request['komentar'] : '',
      filePath: request['file'] ?? '',
      file: null,
    );
  }
  static List<RequestModel> fromSupabaseList(List<Map<String, dynamic>> requests) {
    return requests.map((request) => RequestModel.fromSupabase(request)).toList();
  }

  factory RequestModel.empty() {
    return RequestModel(
      id: 0,
      type: 0,
      status: 0,
      requester: EmployeeModel.empty(),
      approvalTime: null,
      rejectTime: null,
    );
  }

  factory RequestModel.copyWith(RequestModel request, {int? id, int? type, int? status, DateTime? startDateTime, DateTime? endDateTime, DateTime? approvalTime, DateTime? rejectTime, String? reason, String? comment, String? filePath, File? file, EmployeeModel? requester, EmployeeModel? approver, EmployeeModel? rejecter}) {
    return RequestModel(
      id: id ?? request.id,
      type: type ?? request.type,
      status: status ?? request.status,
      startDateTime: startDateTime ?? request.startDateTime,
      endDateTime: endDateTime ?? request.endDateTime,
      approvalTime: approvalTime ?? request.approvalTime,
      rejectTime: rejectTime ?? request.rejectTime,
      reason: reason ?? request.reason,
      comment: comment ?? request.comment,
      filePath: filePath ?? request.filePath,
      file: file ?? request.file,
      requester: requester ?? request.requester,
      approver: approver ?? request.approver,
      rejecter: rejecter ?? request.rejecter,
    );
  }
}
