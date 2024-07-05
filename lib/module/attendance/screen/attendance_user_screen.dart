import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_user_list.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_range_picker.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceUserScreen extends StatefulWidget {
  const AttendanceUserScreen({super.key});

  @override
  State<AttendanceUserScreen> createState() => _AttendanceUserScreenState();
}

class _AttendanceUserScreenState extends State<AttendanceUserScreen> {
  final TextEditingController dateController = TextEditingController();
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    _dateRange = context.read<AttendanceViewModel>().selectedUserDate;
    dateController.text = '${parseDateToStringFormatted(_dateRange.start)} - ${parseDateToStringFormatted(_dateRange.end)}';
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Absensi',
        isBackButton: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: dynamicPaddingAll(16, context),
            child: Container(
              padding: dynamicPaddingSymmetric(0, 10, context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600]!,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                  contentPadding: dynamicPaddingSymmetric(12, 16, context),
                  labelText: 'Filter Tanggal',
                  labelStyle: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
                  suffixIcon: NanyangDateRangePicker(
                    color: ColorTemplate.violetBlue,
                    selectedDateRange: _dateRange,
                    onDateRangePicked: (date) {
                      dateController.text = '${DateFormat('dd/MM/yyyy').format(date.start)} - ${DateFormat('dd/MM/yyyy').format(date.end)}';
                      context.read<AttendanceViewModel>().selectedUserDate = date;
                      context.read<AttendanceViewModel>().getUserAttendance();
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Expanded(child: AttendanceUserList())
        ],
      ),
    );
  }
}