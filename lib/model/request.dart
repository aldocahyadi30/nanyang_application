class RequestModel {
  final int id;
  final int type;
  final int status;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final DateTime? approvalTime;
  final DateTime? rejectTime;
  final int requesterId;
  final String requesterName;
  final int? approverId;
  final String? approverName;
  final int? rejecterId;
  final String? rejecterName;
  final String? reason;
  final String? comment;
  final String? file;

  RequestModel({
    required this.id,
    required this.type,
    required this.status,
    this.startDateTime,
    this.endDateTime,
    this.approvalTime,
    this.rejectTime,
    required this.requesterId,
    required this.requesterName,
    this.approverId = 0,
    this.approverName = '',
    this.rejecterId = 0,
    this.rejecterName = '',
    this.reason,
    this.comment,
    this.file,
  });

  static List<RequestModel> fromSupabaseList(List<Map<String, dynamic>> requests) {
    return requests.map((request) {
      bool haveApprover = request['approver'] != null;
      bool haveRejecter = request['penolak'] != null;

      return RequestModel(
        id: request['id_izin'],
        type: request['jenis'],
        status: request['status'],
        startDateTime: request['waktu_mulai'] == null ? null : DateTime.tryParse(request['waktu_mulai']),
        endDateTime: request['waktu_akhir'] == null ? null : DateTime.tryParse(request['waktu_akhir']),
        approvalTime: request['waktu_approve'] == null ? null : DateTime.tryParse(request['waktu_approve']),
        rejectTime: request['waktu_tolak'] == null ? null : DateTime.tryParse(request['waktu_tolak']),
        requesterId: request['karyawan']['id_karyawan'],
        requesterName: request['karyawan']['nama'],
        approverId: haveApprover ? request['approver']['id_karyawan'] : null,
        approverName: haveApprover ? request['approver']['nama'] : null,
        rejecterId: haveRejecter ? request['penolak']['id_karyawan'] : null,
        rejecterName: haveRejecter ? request['penolak']['nama'] : null,
        reason: request['alasan'] ?? '',
        comment: haveRejecter || haveApprover ? request['komentar'] : '',
        file: request['file'] ?? '',
      );
    }).toList();
  }
}
