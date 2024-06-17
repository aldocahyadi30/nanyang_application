import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/date_viewmodel.dart';
import 'package:provider/provider.dart';

class NanyangDatePicker extends StatefulWidget {
  final TextEditingController? controller;
  final Color color;
  final DateTime? selectedDate;
  final bool isDisabled;
  final Function(DateTime)? onDatePicked;

  const NanyangDatePicker({
    super.key,
    this.controller,
    this.color = ColorTemplate.violetBlue,
    this.selectedDate,
    this.isDisabled = false,
    this.onDatePicked,
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
        // selectedDate = Provider.of<DateViewModel>(context, listen: false).initializeDateForPicker(widget.controller!, widget.type);
        selectedDate = DateTime.now();
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
      setState(
        () {
          selectedDate = picked;
          if (widget.controller != null) {
            widget.controller!.text = DateFormat('dd/MM/yyyy').format(selectedDate);
          }

        },
      );
      if (widget.onDatePicked != null) {
        widget.onDatePicked!(picked);
      }
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
