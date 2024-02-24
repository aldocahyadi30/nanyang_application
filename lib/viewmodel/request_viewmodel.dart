import 'package:flutter/material.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/service/request_service.dart';

class RequestViewModel extends ChangeNotifier {
  final RequestService _requestService;

  RequestViewModel({required RequestService requestService})
      : _requestService = requestService;

  Future<List<RequestModel>?> getDashboardRequest() async {
    try {
      List<RequestModel> request = await _requestService.getDashboardRequest();
      return request;
    } catch (e) {
      // Handle error
      return null;
    }
  }
}