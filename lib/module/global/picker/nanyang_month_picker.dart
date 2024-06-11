import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/date_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class NanyangMonthPicker extends StatefulWidget {
  final TextEditingController? controller;
  final String type;
  final Color color;
  final DateTime? selectedDate;
  final bool isDisabled;
  const NanyangMonthPicker({super.key, this.controller, required this.type, this.color = Colors.blue, this.selectedDate, this.isDisabled = false});

  @override
  State<NanyangMonthPicker> createState() => _NanyangMonthPickerState();
}

class _NanyangMonthPickerState extends State<NanyangMonthPicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      Future.delayed(Duration.zero, () {
        selectedDate = widget.selectedDate!;
        widget.controller!.text = DateFormat('MMMM yyyy').format(selectedDate);
      });
    } else {
      Future.delayed(Duration.zero, () {
        selectedDate = Provider.of<DateViewModel>(context, listen: false).initializeDateForPicker(widget.controller!, widget.type);
      });
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        if (widget.controller != null) {
          widget.controller!.text = DateFormat('MMMM yyyy').format(selectedDate);
        }
        if (widget.type == 'salary-user') {
          Provider.of<DateProvider>(context, listen: false).setSalaryDate(selectedDate);
        } else if (widget.type == 'salary-admin') {
          Provider.of<SalaryViewModel>(context, listen: false).setDate(selectedDate);
          Provider.of<SalaryViewModel>(context, listen: false).getSalary();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isDisabled ? null : () => _selectMonth(context),
      icon: Icon(Icons.calendar_today, color: widget.isDisabled ? Colors.grey : widget.color),
    );
  }
}
