import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:provider/provider.dart';

class Timepicker extends StatefulWidget {
  final TextEditingController controller;
  final Color color;
  const Timepicker(
      {Key? key, required this.controller, this.color = Colors.blue})
      : super(key: key);

  @override
  State<Timepicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<Timepicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.controller.text = TimeOfDay.now().format(context);
    });
  }


  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
    if (picked != null) {
      setState(() {
        widget.controller.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _selectTime(context),
      icon: Icon(Icons.access_time, color: widget.color),
    );
  }
}
