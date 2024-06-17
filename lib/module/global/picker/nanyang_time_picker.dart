import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';

class NanyangTimePicker extends StatefulWidget {
  final Color color;
  final TimeOfDay? selectedTime;
  final bool isDisabled;
  final Function(TimeOfDay)? onTimePicked;

  const NanyangTimePicker({super.key, this.color = ColorTemplate.violetBlue, this.selectedTime, this.isDisabled = false, this.onTimePicked});

  @override
  State<NanyangTimePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<NanyangTimePicker> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.selectedTime != null) {
      Future.delayed(Duration.zero, () {
        selectedTime = widget.selectedTime!;
      });
    }else{
      Future.delayed(Duration.zero, () {
        selectedTime = TimeOfDay.now();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
      if (widget.onTimePicked != null) {
        widget.onTimePicked!(selectedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.isDisabled ? null :() => _selectTime(context),
      icon: Icon(Icons.access_time, color: widget.isDisabled ? Colors.grey : widget.color),
    );
  }
}