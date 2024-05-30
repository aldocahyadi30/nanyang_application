import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:provider/provider.dart';

class DateViewModel extends ChangeNotifier {
  final DateProvider _dateProvider = Provider.of<DateProvider>(navigatorKey.currentContext!, listen: false);

  DateViewModel();

  DateTime initializeDateForPicker(TextEditingController controller, String type) {
    DateTime selectedDate;

    if (type == 'attendance-worker') {
      selectedDate = _dateProvider.attendanceWorkerDate;
      controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    } else if (type == 'attendance-labor') {
      selectedDate = _dateProvider.attendanceLaborDate;
      controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    } else if (type == 'salary-user' || type == 'salary-admin') {
      selectedDate = _dateProvider.attendanceLaborDate;
      controller.text = DateFormat('MMMM yyyy').format(selectedDate);
    } else {
      selectedDate = DateTime.now();
      controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    }

    return selectedDate;
  }

  DateTimeRange? initializeDateRangeForPicker(TextEditingController controller, String type) {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
    DateTimeRange? selectedDateRange;

    if (type == 'attendance-user') {
      selectedDateRange = _dateProvider.attendanceUserDate;
      controller.text = '${DateFormat('dd/MM/yyyy').format(selectedDateRange.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange.end)}';
    } else if (type == 'request') {
      selectedDateRange = _dateProvider.requestDate;
      controller.text = selectedDateRange == null
          ? ''
          : '${DateFormat('dd/MM/yyyy').format(selectedDateRange.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange.end)}';
    } else {
      selectedDateRange = DateTimeRange(start: startOfMonth, end: endOfMonth);
      controller.text = '${DateFormat('dd/MM/yyyy').format(selectedDateRange.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange.end)}';
    }

    return selectedDateRange;
  }
}
