class RequestModel {
  final String id;
  final int requestTypeId;
  final String requestTypeName;
  final int requesterId;
  final String requesterName;
  final int approverId;
  final String approverName;
  final int status;
  final String startDate;
  final String endDate;
  final String reason;
  final String comment;

  RequestModel({
    required this.id,
    required this.requestTypeId,
    required this.requestTypeName,
    required this.requesterId,
    required this.requesterName,
    required this.approverId,
    required this.approverName,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.comment,
  });

  static List<RequestModel> fromSupabaseList(
      List<Map<String, dynamic>> requests) {
    return requests.map((request) {
      return RequestModel(
        id: request['request_id'],
        requestTypeId: request['AttendanceRequestType']['request_type_id'],
        requestTypeName: request['AttendanceRequestType']['name'],
        requesterId: request['Requester']['employee_id'],
        requesterName: request['Requester']['name'],
        approverId: request['Approver']['employee_id'],
        approverName: request['Approver']['name'],
        status: request['status'],
        startDate: request['start_date'],
        endDate: request['end_date'],
        reason: request['reason'],
        comment: request['comment'],
      );
    }).toList();
  }
}
