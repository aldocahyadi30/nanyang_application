import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/service/announcement_service.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementService _announcementService;

  AnnouncementViewModel({required AnnouncementService announcementService})
      : _announcementService = announcementService;

  Future<List<AnnouncementModel>?> getDashboardAnnouncement() async {
    try {
      List<AnnouncementModel> announcement = await _announcementService.getDashboardAnnoucement();
      return announcement;
    } catch (e) {
      // Handle error
      return null;
    }
  }
}