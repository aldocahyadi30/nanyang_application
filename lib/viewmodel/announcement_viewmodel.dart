import 'package:flutter/material.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementService _announcementService;

  AnnouncementViewModel({required AnnouncementService announcementService}) : _announcementService = announcementService;

  Future<List<AnnouncementModel>?> getDashboardAnnouncement() async {
    try {
      List<AnnouncementModel> announcement = await _announcementService.getDashboardAnnouncement();
      return announcement;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<List<AnnouncementModel>?> getAnnouncement() async{
    try{
      List<AnnouncementModel> announcement = await _announcementService.getAnnouncement();
      return announcement;
    } catch (e){
      List<AnnouncementModel> announcement = [];
      if (e is PostgrestException){
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return announcement;
    }
  }

  Future<List<AnnouncementCategoryModel>?> getAnnouncementCategory() async {
    try {
      List<AnnouncementCategoryModel> category = await _announcementService.getAnnouncementCategory();
      return category;
    } catch (e) {
      List<AnnouncementCategoryModel> category = [];
      if (e is PostgrestException) {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
      return category;
    }
  }

  Future<void> storeAnnouncement(AnnouncementModel announcement) async {
    try {
      await _announcementService.storeAnnouncement(announcement);
      Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Berhasil menambahkan pengumuman!', 'success');
    } catch (e) {
      if (e is PostgrestException) {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Terjadi kesalahan, mohon laporkan!', 'error');
      } else {
        Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false).showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
      }
    }
  }
}
