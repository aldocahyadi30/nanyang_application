import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/module/announcement/screen/announcement_detail_screen.dart';
import 'package:nanyang_application/module/announcement/screen/announcement_form_screen.dart';
import 'package:nanyang_application/module/announcement/screen/announcement_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementService _announcementService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final NavigationService _navigationService = Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  List<AnnouncementModel> _announcement = [];
  List<AnnouncementModel> _announcementDashboard = [];
  List<AnnouncementCategoryModel> _announcementCategory = [];
  AnnouncementModel _selectedAnnouncement = AnnouncementModel.empty();
  List<int> selectedCategory = [];

  AnnouncementViewModel({required AnnouncementService announcementService}) : _announcementService = announcementService;

  get announcement {
    return _announcement.where((element) {
      if (element.isValid && element.isSend) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }
  get announcementDashboard => _announcementDashboard;
  get announcementCategory => _announcementCategory;
  AnnouncementModel get selectedAnnouncement => _selectedAnnouncement;

  set selectedAnnouncement(AnnouncementModel model) {
    _selectedAnnouncement = model;
    notifyListeners();
  }

  Future<void> getDashboardAnnouncement() async {
    try {
      List<Map<String, dynamic>> data = await _announcementService.getDashboardAnnouncement();
      _announcementDashboard = AnnouncementModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement get dashboard error: ${e.message}');
      } else {
        debugPrint('Announcement get dashboard error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getAnnouncement({List<int> categoryID = const []}) async {
    try {
      List<Map<String, dynamic>> data = [];
      if (categoryID.isEmpty) {
        data = await _announcementService.getAnnouncement();
      } else {
        data = await _announcementService.getAnnouncementByCategory(categoryID);
      }
      _announcement = AnnouncementModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement get error: ${e.message}');
      } else {
        debugPrint('Announcement get error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getAnnouncementCategory() async {
    try {
      List<Map<String, dynamic>> data = await _announcementService.getAnnouncementCategory();
      _announcementCategory = AnnouncementCategoryModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement get category error: ${e.message}');
      } else {
        debugPrint('Announcement get category error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }





  Future<void> storeAnnouncementCategory(String title, String color) async {
    try {
      await _announcementService.storeAnnouncementCategory(title, color);
      _toastProvider.showToast('Berhasil menambahkan kategori pengumuman!', 'success');

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement store category error: ${e.message}');
      } else {
        debugPrint('Announcement store category error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> updateAnnouncementCategory(AnnouncementCategoryModel model, String title, String color) async {
    try {
      await _announcementService.updateAnnouncementCategory(model.id, title, color);
      _toastProvider.showToast('Berhasil mengubah kategori pengumuman!', 'success');

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement update category error: ${e.message}');
      } else {
        debugPrint('Announcement update catgeory error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> index()async{
    await getAnnouncement().then((_){
      _navigationService.navigateTo(const AnnouncementScreen());
    });
  }

  void create(){
    _selectedAnnouncement = AnnouncementModel.empty();
    _navigationService.navigateTo(const AnnouncementFormScreen());
  }

  Future<void> store(AnnouncementModel model) async {
    try {
      await _announcementService.storeAnnouncement(model).then((_) {
        _toastProvider.showToast('Berhasil menambahkan pengumuman!', 'success');
        getAnnouncement();
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement store error: ${e.message}');
      } else {
        debugPrint('Announcement store error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  void detail(AnnouncementModel model){
    _selectedAnnouncement = model;
    _navigationService.navigateTo(const AnnouncementDetailScreen());
  }

  void edit(AnnouncementModel model){
    _selectedAnnouncement = model;
    _navigationService.navigateTo(const AnnouncementFormScreen());
  }

  Future<void> update(AnnouncementModel model) async {
    try {
      await _announcementService.updateAnnouncement(model).then((_) {
        _toastProvider.showToast('Berhasil update pengumuman!', 'success');
        getAnnouncement();
      });
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement store error: ${e.message}');
      } else {
        debugPrint('Announcement store error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> delete() async{
    await _announcementService.deleteAnnouncement(_selectedAnnouncement.id).then((_) {
      _toastProvider.showToast('Berhasil menghapus pengumuman!', 'success');
      getAnnouncement();
      _navigationService.goBack();
    });
  }

}