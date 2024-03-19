import 'package:flutter/material.dart';

class FormSwitchField extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const FormSwitchField({super.key, required this.title, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Switch(
            value: value,
            activeColor: Colors.blue,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}