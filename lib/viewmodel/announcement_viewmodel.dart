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

  AnnouncementViewModel({required AnnouncementService announcementService})
      : _announcementService = announcementService;

  Future<List<AnnouncementModel>> getDashboardAnnouncement() async {
    try {
      List<Map<String,dynamic>> data = await _announcementService.getDashboardAnnouncement();
      return AnnouncementModel.fromSupabaseList(data);
    } catch (e) {
      List<AnnouncementModel> announcement = [];
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return announcement;
    }
  }

  Future<List<AnnouncementModel>?> getAnnouncement() async {
    try {
      List<Map<String,dynamic>> data = await _announcementService.getAnnouncement();
      return AnnouncementModel.fromSupabaseList(data);
    } catch (e) {
      List<AnnouncementModel> announcement = [];
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return announcement;
    }
  }

  Future<List<AnnouncementCategoryModel>?> getAnnouncementCategory() async {
    try {
      List<Map<String,dynamic>> data = await _announcementService.getAnnouncementCategory();
      return AnnouncementCategoryModel.fromSupabaseList(data);
    } catch (e) {
      List<AnnouncementCategoryModel> category = [];
      if (e is PostgrestException) {
        debugPrint('Announcement error: ${e.message}');
        _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        debugPrint('Announcement error: ${e.toString()}');
        _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return category;
    }
  }

  Future<void> storeAnnouncement(
      int categoryId, String title, String content, bool postLater, String date, String time) async {
    try {
      DateTime tempDate = DateFormat('dd-MM-yyyy').parse(date);
      DateTime tempTime = DateFormat('HH:mm').parse(time);
      DateTime dateTime = DateTime(tempDate.year, tempDate.month, tempDate.day, tempTime.hour, tempTime.minute);

      await _announcementService.storeAnnouncement(categoryId, title, content, postLater, dateTime);
      _toastProvider.showToast('Berhasil menambahkan pengumuman!', 'success');
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