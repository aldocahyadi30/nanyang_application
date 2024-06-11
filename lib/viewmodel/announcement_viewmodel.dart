import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementService _announcementService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  List<AnnouncementModel> _announcement = [];
  List<AnnouncementModel> _announcementDashboard = [];
  List<AnnouncementCategoryModel> _announcementCategory = [];
  List<int> selectedCategory = [];

  AnnouncementViewModel({required AnnouncementService announcementService}) : _announcementService = announcementService;

  get announcement => _announcement;
  get announcementDashboard => _announcementDashboard;
  get announcementCategory => _announcementCategory;

  Future<void> getDashboardAnnouncement() async {
    try {
      List<Map<String, dynamic>> data = await _announcementService.getDashboardAnnouncement();
      _announcementDashboard = AnnouncementModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
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
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> getAnnouncementCategory() async {
    try {
      List<Map<String, dynamic>> data = await _announcementService.getAnnouncementCategory();
      _announcementCategory = AnnouncementCategoryModel.fromSupabaseList(data);

      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> store(int categoryId, String title, String content, String date, String time, int duration, bool isPosted) async {
    try {
      DateTime tempDate = DateFormat('dd-MM-yyyy').parse(date);
      DateTime tempTime = DateFormat('HH:mm').parse(time);
      DateTime postDate = DateTime(tempDate.year, tempDate.month, tempDate.day, tempTime.hour, tempTime.minute);

      await _announcementService.storeAnnouncement(categoryId, title, content, postDate, duration, isPosted);
      _toastProvider.showToast('Berhasil menambahkan pengumuman!', 'success');

      getAnnouncement();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> storeAnnouncementCategory(String title, String color) async {
    try {
      await _announcementService.storeAnnouncementCategory(title, color);
      _toastProvider.showToast('Berhasil menambahkan kategori pengumuman!', 'success');

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }

  Future<void> updateAnnouncementCategory(AnnouncementCategoryModel model, String title, String color) async {
    try {
      await _announcementService.updateAnnouncementCategory(model.id, title, color);
      _toastProvider.showToast('Berhasil mengubah kategori pengumuman!', 'success');

      getAnnouncementCategory();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }
}
