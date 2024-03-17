import 'package:flutter/material.dart';

class FormRadioButton extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final String? groupValue;
  final String value;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final ValueChanged<String> onChanged;
  const FormRadioButton(
      {super.key,
      required this.label,
      this.padding = const EdgeInsets.all(0.0),
      required this.groupValue,
      required this.value,
      this.fontSize = 16.0,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      groupValue: groupValue,
      value: value,
      onChanged: (String? newValue) {
        onChanged(newValue!);
      },
      title: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
      activeColor: Colors.blue,
    );
  }
}
