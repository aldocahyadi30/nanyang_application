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
  final Color color;
  final DateTimeRange? selectedDateRange;
  final bool isDisabled;
  final Function(DateTimeRange)? onDateRangePicked;

  const NanyangDateRangePicker(
      {super.key, this.controller, this.color = ColorTemplate.violetBlue, this.selectedDateRange, this.isDisabled = false, this.onDateRangePicked});

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
        widget.controller!.text = '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}';
      });
    } else {
      Future.delayed(Duration.zero, () {
        selectedDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
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
        return child!;
      },
    );
    if (picked != null && picked != selectedDateRange) {
      setState(
        () {
          selectedDateRange = picked;
        },
      );
      if (widget.onDateRangePicked != null) {
        widget.onDateRangePicked!(selectedDateRange!);
      }
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
