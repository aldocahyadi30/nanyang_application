import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';

class FormSwitchField extends StatelessWidget {
  final String title;
  final Color titleColor;
  final bool value;
  final Color color;
  final ValueChanged<bool>? onChanged;

  const FormSwitchField(
      {super.key,
      required this.title,
      this.titleColor = Colors.black,
      required this.value,
      this.onChanged,
      this.color = ColorTemplate.violetBlue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Switch(
            value: value,
            activeColor: color,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}