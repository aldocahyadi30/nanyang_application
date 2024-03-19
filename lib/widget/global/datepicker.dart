import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:provider/provider.dart';

class Datepicker extends StatefulWidget {
  final TextEditingController controller;
  final String type;
  final Color color;

  const Datepicker({
    Key? key,
    required this.controller,
    required this.type,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  State<Datepicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<Datepicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.type == 'attendance-worker') {
        selectedDate = Provider.of<DateProvider>(context, listen: false).attendanceWorkerDate;
      } else if (widget.type == 'attendance-labor') {
        selectedDate = Provider.of<DateProvider>(context, listen: false).attendanceLaborDate;
      } else if (widget.type == 'request') {
        selectedDate = Provider.of<DateProvider>(context, listen: false).requestDate;
      } else {
        selectedDate = DateTime.now();
      }
      widget.controller.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.controller.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        if (widget.type == 'attendance-worker') {
          Provider.of<DateProvider>(context, listen: false).setAttendanceWorkerDate(selectedDate);
        } else if (widget.type == 'attendance-labor') {
          Provider.of<DateProvider>(context, listen: false).setAttendanceLaborDate(selectedDate);
        } else if (widget.type == 'request') {
          Provider.of<DateProvider>(context, listen: false).setRequestDate(selectedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _selectDate(context),
      icon: Icon(Icons.calendar_today, color: widget.color),
    );
  }
}