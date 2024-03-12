import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:provider/provider.dart';

class Datepicker extends StatefulWidget {
  final TextEditingController controller;
  final String type;
  const Datepicker({Key? key, required this.controller, required this.type})
      : super(key: key);

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
        selectedDate = Provider.of<DateProvider>(context, listen: false)
            .attendanceWorkerDate;
      } else if (widget.type == 'attendance-labor') {
        selectedDate = Provider.of<DateProvider>(context, listen: false)
            .attendanceLaborDate;
      } else if (widget.type == 'request') {
        selectedDate =
            Provider.of<DateProvider>(context, listen: false).requestDate;
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
          Provider.of<DateProvider>(context, listen: false)
              .setAttendanceWorkerDate(selectedDate);
        } else if (widget.type == 'attendance-labor') {
          Provider.of<DateProvider>(context, listen: false)
              .setAttendanceLaborDate(selectedDate);
        } else if (widget.type == 'request') {
          Provider.of<DateProvider>(context, listen: false)
              .setRequestDate(selectedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        readOnly: true,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: 'Filter Tanggal',
          labelStyle: const TextStyle(color: Colors.blue),
          suffixIcon: IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
