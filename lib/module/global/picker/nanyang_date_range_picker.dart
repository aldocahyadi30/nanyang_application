import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/date_viewmodel.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class NanyangDateRangePicker extends StatefulWidget {
  final TextEditingController? controller;
  final String type;
  final Color color;
  final DateTimeRange? selectedDateRange;
  final bool isDisabled;

  const NanyangDateRangePicker(
      {super.key, this.controller, required this.type, this.color = ColorTemplate.violetBlue, this.selectedDateRange, this.isDisabled = false});

  @override
  State<NanyangDateRangePicker> createState() => _NanyangDateRangePickerState();
}

class _NanyangDateRangePickerState extends State<NanyangDateRangePicker> {
  late DateTimeRange? selectedDateRange;

  @override
  initState() {
    super.initState();
    if (widget.selectedDateRange != null) {
      Future.delayed(Duration.zero, () {
        selectedDateRange = widget.selectedDateRange!;
        widget.controller!.text =
            '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}';
      });
    } else {
      Future.delayed(Duration.zero, () {
        selectedDateRange = Provider.of<DateViewModel>(context, listen: false)
            .initializeDateRangeForPicker(widget.controller!, widget.type);
      });
    }
  }

  Future<void> _selectRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              surface: ColorTemplate.periwinkle,
              onSurface: ColorTemplate.violetBlue,
              primary: ColorTemplate.violetBlue,
            ),
            dialogBackgroundColor: ColorTemplate.periwinkle,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
        if (widget.controller != null) {
          widget.controller!.text =
              '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}';
        }

        if (widget.type == 'attendance-user') {
          Provider.of<DateProvider>(context, listen: false).setAttendanceUserDate(selectedDateRange!);
          Provider.of<AttendanceViewModel>(context, listen: false).getUserAttendance();
        }else if (widget.type == 'request') {
          Provider.of<DateProvider>(context, listen: false).setRequestDate(selectedDateRange!);
          Provider.of<RequestViewModel>(context, listen: false).addFilter(date: selectedDateRange!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isDisabled ? null : () => _selectRange(context),
      icon: Icon(
        Icons.calendar_today,
        color: widget.isDisabled ? Colors.grey : widget.color,
      ),
    );
  }
}