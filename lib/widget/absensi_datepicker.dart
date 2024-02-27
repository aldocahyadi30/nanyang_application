import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/attendance_date_provider.dart';
import 'package:provider/provider.dart';

class AbsensiDatePicker extends StatefulWidget {
  final TextEditingController controller;
  const AbsensiDatePicker({Key? key, required this.controller})
      : super(key: key);

  @override
  State<AbsensiDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<AbsensiDatePicker> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);

    Future.delayed(Duration.zero, () {
      Provider.of<DateProvider>(context, listen: false)
          .setDate(widget.controller.text);
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
        widget.controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        Provider.of<DateProvider>(context, listen: false)
            .setDate(widget.controller.text);
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
