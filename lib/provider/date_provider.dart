import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateProvider extends ChangeNotifier {
  late DateTime _attendanceWorkerDate;
  late DateTime _attendanceLaborDate;
  late DateTime _requestDate;

  DateProvider() {
    _attendanceWorkerDate = DateTime.now();
    _attendanceLaborDate = DateTime.now();
    _requestDate = DateTime.now();
  }

  DateTime get attendanceWorkerDate => _attendanceWorkerDate;
  DateTime get attendanceLaborDate => _attendanceLaborDate;
  DateTime get requestDate => _requestDate;

  String get attendanceWorkerDateString =>
      DateFormat('yyyy-MM-dd').format(_attendanceWorkerDate);
  String get attendanceLaborDateString =>
      DateFormat('yyyy-MM-dd').format(_attendanceLaborDate);
  String get requestDateString => DateFormat('yyyy-MM-dd').format(_requestDate);

  String get attendanceWorkerDateStringFormat =>
      DateFormat('dd-MM-yyyy').format(_attendanceWorkerDate);
  String get attendanceLaborDateStringFormat =>
      DateFormat('dd-MM-yyyy').format(_attendanceLaborDate);
  String get requestDateStringFormat => DateFormat('dd-MM-yyyy').format(_requestDate);

  void setAttendanceWorkerDate(DateTime newDate) {
    _attendanceWorkerDate = newDate;
    notifyListeners();
  }

  void setAttendanceLaborDate(DateTime newDate) {
    _attendanceLaborDate = newDate;
    notifyListeners();
  }

  void setRequestDate(DateTime newDate) {
    _requestDate = newDate;
    notifyListeners();
  }
}
