import 'package:flutter/material.dart';

class FormPickerField extends StatefulWidget {
  final String title;
  final Widget picker;
  final TextEditingController controller;

  const FormPickerField({super.key, required this.title, required this.picker, required this.controller});

  @override
  State<FormPickerField> createState() => _FormPickerFieldState();
}

class _FormPickerFieldState extends State<FormPickerField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: widget.controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tolong isi inputan ini';
            }
            return null;
          },
          readOnly: true,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.blue,
              suffixIcon: widget.picker),
        ),
      ],
    );
  }
}