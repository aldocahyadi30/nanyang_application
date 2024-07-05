import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/model/configuration.dart';
import 'package:nanyang_application/model/holiday.dart';
import 'package:nanyang_application/model/position.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/configuration_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfigurationViewModel extends ChangeNotifier {
  final ConfigurationService _configurationService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  ConfigurationModel currentConfig = ConfigurationModel.empty();
  List<HolidayModel> holidayList = [];
  List<PositionModel> positionList = [];
  List<AnnouncementCategoryModel> announcementCategoryList = [];
  HolidayModel _selectedHoliday = HolidayModel.empty();
  PositionModel _selectedPosition = PositionModel.empty();
  AnnouncementCategoryModel _selectedAnnouncementCategory = AnnouncementCategoryModel.empty();

  ConfigurationViewModel({required ConfigurationService configurationService}) : _configurationService = configurationService;

  HolidayModel get selectedHoliday => _selectedHoliday;
  PositionModel get selectedPosition => _selectedPosition;
  ConfigurationModel get configuration => currentConfig;
  AnnouncementCategoryModel get selectedAnnouncementCategory => _selectedAnnouncementCategory;
  get holiday {
    return holidayList.reversed.toList();
  }

  get position => positionList;
  get announcementCategory => announcementCategoryList;

  void selectHoliday(HolidayModel model) {
    _selectedHoliday = model;
    notifyListeners();
  }

  void selectPosition(PositionModel model) {
    _selectedPosition = model;
    notifyListeners();
  }


  void setConfiguration(ConfigurationModel configuration) {
    currentConfig = configuration;
    notifyListeners();
  }

  void setAnnouncementCategory(List<AnnouncementCategoryModel> announcementCategory) {
    announcementCategoryList = announcementCategory;
    notifyListeners();
  }

  Future<void> getConfiguration() async {
    try {
      List<Map<String, dynamic>> data = await _configurationService.getConfiguration();
      currentConfig = ConfigurationModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Configuration error: ${e.message}');
      } else {
        debugPrint('Get Configuration error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getHoliday() async {
    try {
      DateTime now = DateTime.now();
      DateTime startYear = DateTime(now.year, 1, 1);
      DateTime endYear = DateTime(now.year, 12, 31);
      List<dynamic> holidayAPI = await _configurationService.getHolidayByAPI();
      List<Map<String, dynamic>> holidayDB = await _configurationService.getHolidayByDB(startYear.toIso8601String(), endYear.toIso8601String());

      holidayList = HolidayModel.fromSupabaseList(holidayDB, holidayAPI.where((element) => element['is_national_holiday'] == true).toList());
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Holiday error: ${e.message}');
      } else {
        debugPrint('Get Holiday error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> updateHoliday(int type) async {
    try {
      if (type == 1) {
        String name = _selectedHoliday.name;
        String date = _selectedHoliday.date.toIso8601String();
        await _configurationService.saveHoliday(name, date);
      } else {
        int id = _selectedHoliday.id;
        await _configurationService.deleteHoliday(id);
      }

      getHoliday();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Holiday error: ${e.message}');
      } else {
        debugPrint('Update Holiday error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getPosition() async {
    try {
      List<Map<String, dynamic>> data = await _configurationService.getPosition();

      positionList = PositionModel.fromSupabaseList(data);
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Position error: ${e.message}');
      } else {
        debugPrint('Get Position error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> updatePosition(int type, String name, int positionType) async {
    try {
      if (type == 1) {
        await _configurationService.savePosition(name, positionType);
      } else if (type == 2) {
        int id = _selectedPosition.id;
        await _configurationService.updatePosition(id, name, positionType);
      } else {
        int id = _selectedPosition.id;
        await _configurationService.deletePosition(id);
      }

      getPosition();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Position error: ${e.message}');
      } else {
        debugPrint('Update Position error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> updateSalaryConfiguration(double foodAllowanceWorker, double foodAllowanceLabor, int day) async {
    try {
      await _configurationService.updateSalaryConfiguration(foodAllowanceWorker, foodAllowanceLabor, day);
      getConfiguration();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Salary Configuration error: ${e.message}');
      } else {
        debugPrint('Update Salary Configuration error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getAnnouncementCategory() async {
    try {
      List<Map<String, dynamic>> data = await _configurationService.getAnnouncementCategory();
      announcementCategoryList = AnnouncementCategoryModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> updateAnnouncementCategory(int type) async {
    try {
      if (type == 1) {
        await _configurationService.storeAnnouncementCategory(_selectedAnnouncementCategory);
      } else if (type == 2) {
        await _configurationService.updateAnnouncementCategory(_selectedAnnouncementCategory);
      } else {
        await _configurationService.deleteAnnouncementCategory(_selectedAnnouncementCategory.id);
      }

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Announcement Category error: ${e.message}');
      } else {
        debugPrint('Update Announcement Category error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> updatePerformanceThreshold(double value)async{
    try{
      _configurationService.updatePerformanceThreshold(value);
      getConfiguration();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Update Performance Threshold error: ${e.message}');
      } else {
        debugPrint('Update Performance Threshold error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> initialize() async {
    try {
      await getConfiguration();
      await getHoliday();
      await getPosition();
      await getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Initialize Configuration error: ${e.message}');
      } else {
        debugPrint('Initialize Configuration error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }
}