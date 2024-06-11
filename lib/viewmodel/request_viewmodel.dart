import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/home_screen.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/provider/file_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/request_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestViewModel extends ChangeNotifier {
  final RequestService _requestService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final FileProvider _fileProvider = Provider.of<FileProvider>(navigatorKey.currentContext!, listen: false);
  final ConfigurationProvider _configurationProvider = Provider.of<ConfigurationProvider>(navigatorKey.currentContext!, listen: false);
  List<RequestModel> _request = [];
  List<RequestModel> _requestDashboard = [];
  List<int> _filterCategory = [];
  String filterStatus = 'Pending';
  DateTimeRange? filterDate;

  RequestViewModel({required RequestService requestService}) : _requestService = requestService;

  get request {
    List<RequestModel> requestFiltered = _request;

    if (filterStatus == '') {
      requestFiltered = requestFiltered
          .where((element) => element.approver!.id == 0 || element.rejecter!.id == 0 || element.approver!.id != 0 || element.rejecter!.id != 0)
          .toList();
    } else {
      if (filterStatus == 'Pending') {
        requestFiltered = requestFiltered.where((element) => element.approver!.id == 0 && element.rejecter!.id == 0).toList();
      }

      if (filterStatus == 'Approved') {
        requestFiltered = requestFiltered.where((element) => element.approver!.id != 0).toList();
      }

      if (filterStatus == 'Rejected') {
        requestFiltered = requestFiltered.where((element) => element.rejecter!.id != 0).toList();
      }
    }

    if (_filterCategory.isNotEmpty) {
      requestFiltered = requestFiltered.where((element) => _filterCategory.contains(element.type)).toList();
    }

    if (filterDate != null) {
      requestFiltered = requestFiltered.where((element) {
        return element.startDateTime!.isAfter(filterDate!.start) && element.startDateTime!.isBefore(filterDate!.end);
      }).toList();
    }

    return requestFiltered;
  }

  get requestDashboard => _requestDashboard;

  Future<void> getDashboardRequest() async {
    try {
      List<Map<String, dynamic>> data;
      data = await _requestService.getDashboardRequest(_configurationProvider.user.level,
          employeeID: _configurationProvider.isAdmin ? null : _configurationProvider.user.employee.id);

      _requestDashboard = RequestModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request get dashboard error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Request get dashboard error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getRequest() async {
    try {
      List<Map<String, dynamic>> data;
      data = await _requestService.getListRequest(employeeID: _configurationProvider.isAdmin ? null : _configurationProvider.user.employee.id);
      _request = RequestModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request get list error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Request get list error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> store(int type, String reason, {String? fileName, String? startTime, String? endTime, String? startDate, String? endDate}) async {
    try {
      final int employeeID = _configurationProvider.user.employee.id;
      File? file;
      String? startDateTime;
      String? endDateTime;

      if ((fileName != null && fileName != '') && fileName == _fileProvider.fileName) {
        file = _fileProvider.file;
      }
      if (type == 1 || type == 2) {
        if (startTime != null && startTime != '') {
          startDateTime = DateFormat('dd/MM/yyyy HH:mm').parse('$startDate $startTime').toIso8601String();
        }
      } else {
        startDateTime = DateFormat('dd/MM/yyyy HH:mm').parse('$startDate $startTime').toIso8601String();
        endDateTime = DateFormat('dd/MM/yyyy HH:mm').parse('$endDate $endTime').toIso8601String();
      }

      await _requestService.store(employeeID, type, reason, file: file, startTime: startDateTime, endTime: endDateTime);
      _toastProvider.showToast('Permintaan berhasil disimpan!', 'success');

      redirect(const HomeScreen(), true);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request store error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Request store error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> update(RequestModel model, int type, String reason,
      {String? fileName, String? startTime, String? endTime, String? startDate, String? endDate}) async {
    try {
      final int employeeID = _configurationProvider.user.employee.id;
      File? file;
      String? startDateTime;
      String? endDateTime;

      if ((fileName != null && fileName != '' && fileName == model.filePath?.split('/').last) && fileName == _fileProvider.fileName) {
        file = _fileProvider.file;
      }
      if (type == 1 || type == 2) {
        if (startTime != null && startTime != '') {
          startDateTime = DateFormat('dd/MM/yyyy HH:mm').parse('$startDate $startTime').toIso8601String();
        }
      } else {
        startDateTime = DateFormat('dd/MM/yyyy HH:mm').parse('$startDate $startTime').toIso8601String();
        endDateTime = DateFormat('dd/MM/yyyy HH:mm').parse('$endDate $endTime').toIso8601String();
      }

      await _requestService.update(model.id, employeeID, type, reason, file: file, startTime: startDateTime, endTime: endDateTime);
      _toastProvider.showToast('Permintaan berhasil diupdate!', 'success');

      redirect(const HomeScreen(), true);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request update error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Request update error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> response(String type, int id, String? comment) async {
    try {
      final int employeeID = _configurationProvider.user.employee.id;
      if (type == 'approve') {
        await _requestService.approve(id, employeeID, comment);
        _toastProvider.showToast('Permintaan berhasil disetujui!', 'success');
      } else {
        await _requestService.reject(id, employeeID, comment!);
        _toastProvider.showToast('Permintaan berhasil ditolak!', 'success');
      }
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request response error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Request response error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  void addFilter({List<int>? selectedCategory, String? status, DateTimeRange? date}) {
    if (selectedCategory != null) {
      _filterCategory = selectedCategory;
    } else {
      _filterCategory = [];
    }
    if (status != null) {
      filterStatus = status;
    } else {
      filterStatus = 'Pending';
    }
    if (date != null) {
      filterDate = date;
    } else {
      filterDate = null;
    }
    notifyListeners();
  }

  void redirect(Widget screen, bool isReplace) {
    if (isReplace) {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    } else {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );
    }
  }
}
