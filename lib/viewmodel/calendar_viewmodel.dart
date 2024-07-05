import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/holiday.dart';
import 'package:nanyang_application/module/calendar/screen/calendar_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/calendar_service.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:provider/provider.dart';

class CalendarViewmodel extends ChangeNotifier {
  final CalendarService _calendarService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  List<HolidayModel> _holiday = [];
  HolidayModel _selectedHoliday = HolidayModel.empty();
  List<HolidayModel> _selectedList = [];

  CalendarViewmodel({required CalendarService calendarService}) : _calendarService = calendarService;

  List<HolidayModel> get holiday => _holiday;

  HolidayModel get selectedHoliday => _selectedHoliday;

  List<HolidayModel> get selectedList => _selectedList;

  set selectedHoliday(HolidayModel model) {
    _selectedHoliday = model;
    notifyListeners();
  }

  set selectedList(List<HolidayModel> list) {
    _selectedList = list;
    notifyListeners();
  }

  Future<void> getHoliday() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfYear = DateTime(now.year, 1, 1);
      DateTime endOfYear = DateTime(now.year, 12, 31);
      List<Map<String, dynamic>> data =
          await _calendarService.getHoliday(parseDateToString(startOfYear), parseDateToString(endOfYear));
      _holiday = HolidayModel.fromMapList(data);
      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
      _toastProvider.showToast('Terjadi kesalahan, mohon laporkan!', 'error');
    }
  }

  Future<void> index() async {
    await getHoliday();
    _selectedList = [];
    _navigationService.navigateTo(const CalendarScreen());
  }
}