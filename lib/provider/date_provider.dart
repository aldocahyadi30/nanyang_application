import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateProvider extends ChangeNotifier {
  late DateTime _attendanceWorkerDate;
  late DateTime _attendanceLaborDate;
  late DateTimeRange _attendanceUserDate;
  late DateTimeRange? _requestDate;
  late DateTime _salaryDate;

  DateProvider() {
    DateTime now = DateTime.now();
    _attendanceWorkerDate = now;
    _attendanceLaborDate = now;
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    _attendanceUserDate = DateTimeRange(start: startOfWeek, end: endOfWeek);
    _requestDate = null;
    _salaryDate = now;
  }

  DateTime get attendanceWorkerDate => _attendanceWorkerDate;
  DateTime get attendanceLaborDate => _attendanceLaborDate;
  DateTimeRange get attendanceUserDate => _attendanceUserDate;
  DateTime get attendanceUserDateStart => _attendanceUserDate.start;
  DateTime get attendanceUserDateEnd => _attendanceUserDate.end;
  DateTimeRange? get requestDate => _requestDate;
  DateTime get salaryDate => _salaryDate;

  String get attendanceWorkerDateString => DateFormat('yyyy-MM-dd').format(_attendanceWorkerDate);
  String get attendanceLaborDateString => DateFormat('yyyy-MM-dd').format(_attendanceLaborDate);
  String get attendanceUserDateStartString => DateFormat('yyyy-MM-dd').format(_attendanceUserDate.start);
  String get attendanceUserDateEndString => DateFormat('yyyy-MM-dd').format(_attendanceUserDate.end);
  String get requestDateStartString => _requestDate == null ? '' : DateFormat('yyyy-MM-dd').format(_requestDate!.start);
  String get requestDateEndString => _requestDate == null ? '' : DateFormat('yyyy-MM-dd').format(_requestDate!.end);
  String get salaryDateString => DateFormat('yyyy-MM-dd').format(_salaryDate);

  String get attendanceWorkerDateStringFormat => DateFormat('dd/MM/yyyy').format(_attendanceWorkerDate);
  String get attendanceLaborDateStringFormat => DateFormat('dd/MM/yyyy').format(_attendanceLaborDate);
  String get attendanceUserDateStartStringFormat => DateFormat('dd/MM/yyyy').format(_attendanceUserDate.start);
  String get attendanceUserDateEndStringFormat => DateFormat('dd/MM/yyyy').format(_attendanceUserDate.end);
  String get requestDateStartStringFormat =>
      _requestDate == null ? '' : DateFormat('dd/MM/yyyy').format(_requestDate!.start);
  String get requestDateEndStringFormat =>
      _requestDate == null ? '' : DateFormat('dd/MM/yyyy').format(_requestDate!.end);
  String get salaryDateStringFormat => DateFormat('MMMM yyyy').format(_salaryDate);

  void setAttendanceWorkerDate(DateTime newDate) {
    _attendanceWorkerDate = newDate;
    notifyListeners();
  }

  void setAttendanceLaborDate(DateTime newDate) {
    _attendanceLaborDate = newDate;
    notifyListeners();
  }

  void setAttendanceUserDate(DateTimeRange newDate) {
    _attendanceUserDate = newDate;
    notifyListeners();
  }

  void setRequestDate(DateTimeRange? newDate) {
    _requestDate = newDate;
    notifyListeners();
  }

  void setSalaryDate(DateTime newDate) {
    _salaryDate = newDate;
    notifyListeners();
  }
}