import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/performance_labor.dart';
import 'package:nanyang_application/module/performance/screen/performance_admin_screen.dart';
import 'package:nanyang_application/module/performance/screen/performance_labor_detail_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/service/navigation_service.dart';
import 'package:nanyang_application/service/performance_service.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerformanceViewmodel extends ChangeNotifier {
  final PerformanceService _performanceService;
  final ToastProvider _toastProvider = Provider.of<ToastProvider>(navigatorKey.currentContext!, listen: false);
  final NavigationService _navigationService =
      Provider.of<NavigationService>(navigatorKey.currentContext!, listen: false);
  final AuthViewModel _auth = Provider.of<AuthViewModel>(navigatorKey.currentContext!, listen: false);
  List<FlSpot> initialQuote = [];
  List<FlSpot> finalQuote = [];
  List<BarChartGroupData> attendanceeCount = [];
  List<PerformanceLaborModel> laborProduction = [];

  PerformanceViewmodel({required PerformanceService performanceService}) : _performanceService = performanceService;

  get initialQuoteData => initialQuote;

  get finalQuoteData => finalQuote;

  get attendanceData => attendanceeCount;

  List<PerformanceLaborModel> get laborProductionData => laborProduction;

  set setInitialQuoteData(List<FlSpot> data) {
    initialQuote = data;
    notifyListeners();
  }

  set setFinalQuoteData(List<FlSpot> data) {
    finalQuote = data;
    notifyListeners();
  }

  set setAttendanceData(List<BarChartGroupData> data) {
    attendanceeCount = data;
    notifyListeners();
  }

  set laborProductionData(List<PerformanceLaborModel> data) {
    laborProduction = data;
    notifyListeners();
  }

  Future<void> getAttendanceCount() async {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
      List<dynamic> countData =
          await _performanceService.getAttendanceCount(firstDayOfWeek.toIso8601String(), now.toIso8601String());
      List<BarChartGroupData> attendanceeData = [];

      for (int i = 0; i < countData.length; i++) {
        String date = countData[i]['date_list'];
        int day = int.parse(date.split('-')[2]);
        attendanceeData.add(
          BarChartGroupData(x: day, barRods: [
            BarChartRodData(
              toY: countData[i]['attendance1'].toDouble(),
              color: Colors.cyan,
            ),
            BarChartRodData(
              toY: countData[i]['attendance2'].toDouble(),
              color: Colors.pink,
            ),
          ]),
        );
      }

      setAttendanceData = attendanceeData;
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Attendance Count error: ${e.message}');
      } else {
        debugPrint('Attendance Count error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getLaborQuote() async {
    try {
      DateTime now = DateTime.now();
      DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
      List<dynamic> data;
      if (_auth.user.level == 1) {
        data = await _performanceService.getLaborQuote(
            _auth.user.employee.id, firstDayOfWeek.toIso8601String(), now.toIso8601String());
      } else {
        data = await _performanceService.getLaborQuote(0, firstDayOfWeek.toIso8601String(), now.toIso8601String());
      }

      List<FlSpot> initialQuote = [];
      List<FlSpot> finalQuote = [];

      for (int i = 0; i < data.length; i++) {
        String date = data[i]['date_list'];
        int day = int.parse(date.split('-')[2]);
        initialQuote.add(FlSpot(day.toDouble(), data[i]['quote_1'].toDouble()));
        finalQuote.add(FlSpot(day.toDouble(), data[i]['quote_2'].toDouble()));
      }

      setInitialQuoteData = initialQuote;
      setFinalQuoteData = finalQuote;
      notifyListeners();
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Labor Quote error: ${e.message}');
      } else {
        debugPrint('Labor Quote error: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> getLaborProduction() async {
    try {
      DateTime startWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      DateTime endWeek = DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));
      // DateTime startWeek = DateTime(2024, 6, 24);
      // DateTime endWeek = DateTime(2024, 6, 30);
      List<Map<String, dynamic>> data =
          await _performanceService.getLaborProduction(parseDateToString(startWeek), parseDateToString(endWeek));

      laborProduction = PerformanceLaborModel.fromSupabaseList(data);
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint('Get Labor Production error: ${e.message}');
      } else {
        debugPrint('Get Labor Production: ${e.toString()}');
      }
      _toastProvider.showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
    }
  }

  Future<void> index() async {
    await getAttendanceCount();
    await getLaborQuote();
    _navigationService.navigateTo(const PerformanceAdminScreen());
  }

  Future<void> production() async {
    await getLaborProduction();
    _navigationService.navigateTo(const PerformanceLaborDetailScreen());
  }
}