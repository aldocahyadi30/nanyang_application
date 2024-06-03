import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/date_viewmodel.dart';
import 'package:provider/provider.dart';

class NanyangDatePicker extends StatefulWidget {
  final TextEditingController? controller;
  final String type;
  final Color color;
  final DateTime? selectedDate;
  final bool isDisabled;

  const NanyangDatePicker({
    super.key,
    this.controller,
    required this.type,
    this.color = ColorTemplate.violetBlue,
    this.selectedDate,
    this.isDisabled = false,
  });

  @override
  State<NanyangDatePicker> createState() => _NanyangDatePickerState();
}

class _NanyangDatePickerState extends State<NanyangDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      Future.delayed(Duration.zero, () {
        selectedDate = widget.selectedDate!;
        widget.controller!.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    } else {
      Future.delayed(Duration.zero, () {
        selectedDate = Provider.of<DateViewModel>(context, listen: false).initializeDateForPicker(widget.controller!, widget.type);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (widget.controller != null) {
          widget.controller!.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        }
        if (widget.type == 'attendance-worker') {
          Provider.of<DateProvider>(context, listen: false).setAttendanceWorkerDate(selectedDate);
          Provider.of<AttendanceViewModel>(context, listen: false).getAdminAttendance(1);
        } else if (widget.type == 'attendance-labor') {
          Provider.of<DateProvider>(context, listen: false).setAttendanceLaborDate(selectedDate);
          Provider.of<AttendanceViewModel>(context, listen: false).getAdminAttendance(2);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isDisabled ? null : () => _selectDate(context),
      icon: Icon(Icons.calendar_today, color: widget.isDisabled ? Colors.grey : widget.color),
    );
  }
}
