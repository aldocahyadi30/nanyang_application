import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/request/screen/request_category_screen.dart';
import 'package:nanyang_application/module/request/screen/request_detail_screen.dart';
import 'package:nanyang_application/module/request/screen/request_form_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/service/request_service.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestViewModel extends ChangeNotifier {
  final RequestService _requestService;
  final NavigationService _navigationService = Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final ConfigurationViewModel _configViewModel = Provider.of<ConfigurationViewModel>(navigatorKey.currentContext!, listen: false);
  List<RequestModel> _request = [];
  List<RequestModel> _requestDashboard = [];
  RequestModel _selectedRequest = RequestModel.empty();
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
  RequestModel get selectedRequest => _selectedRequest;

  void setSelectedRequest(RequestModel model) {
    _selectedRequest = model;
    notifyListeners();
  }

  Future<void> getDashboardRequest() async {
    try {
      List<Map<String, dynamic>> data;
      data = await _requestService.getDashboardRequest(_configViewModel.user.level,
          employeeID: _configViewModel.user.isAdmin ? null : _configViewModel.user.employee.id);

      _requestDashboard = RequestModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request get dashboard error: ${e.message}');
      } else {
        debugPrint('Request get dashboard error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getRequest() async {
    try {
      List<Map<String, dynamic>> data;
      data = await _requestService.getListRequest(employeeID: _configViewModel.user.isAdmin ? null : _configViewModel.user.employee.id);
      _request = RequestModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request get list error: ${e.message}');
      } else {
        debugPrint('Request get list error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> response(String type, int id, String? comment) async {
    try {
      final int employeeID = _configViewModel.user.employee.id;
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
      } else {
        debugPrint('Request response error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
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

  void category() {
    _navigationService.navigateTo(const RequestCategoryScreen());
  }

  void create(int type) {
    _selectedRequest = RequestModel.empty();
    _navigationService.navigateTo(RequestFormScreen(type: type));
  }

  Future<void> store(RequestModel model) async {
    try {
      model.requester = _configViewModel.user.employee;

      await _requestService.store(model).then((_){
        getRequest();
        _toastProvider.showToast('Permintaan berhasil dibuat!', 'success');
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request store error: ${e.message}');
      } else {
        debugPrint('Request store error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  void edit(RequestModel model) {

    _selectedRequest = model;
    _navigationService.navigateTo(RequestFormScreen(type: model.type));
  }

  Future<void> update(RequestModel model) async {
    try {
      model.requester = _configViewModel.user.employee;

      await _requestService.update(model).then((_){
        getRequest();
        _toastProvider.showToast('Permintaan berhasil diupdate!', 'success');
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request update error: ${e.message}');
      } else {
        debugPrint('Request update error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> delete()async{
    try{
      await _requestService.delete(_selectedRequest.id).then((_){
        getRequest();
        _toastProvider.showToast('Permintaan berhasil dihapus!', 'success');
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Request delete error: ${e.message}');
      } else {
        debugPrint('Request delete error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  void detail(RequestModel model){
    _selectedRequest = model;
    _navigationService.navigateTo(const RequestDetailScreen());
  }
}