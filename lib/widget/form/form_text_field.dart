import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextEditingController controller;
  const FormTextField({super.key, required this.title, this.maxLines = 1, required this.controller});

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
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tolong isi inputan ini';
            }
            return null;
          },
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            focusColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}