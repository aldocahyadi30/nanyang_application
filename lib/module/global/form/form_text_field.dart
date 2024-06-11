import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';

class FormTextField extends StatefulWidget {
  final String title;
  final Color titleColor;
  final Color fillColor;
  final Color textColor;
  final int maxLines;
  final bool isReadOnly;
  final bool isRequired;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final String? initialValue;
  final String? Function(String?) validator;
  final void Function(String?)? onChanged;

  const FormTextField({
    super.key,
    required this.title,
    this.titleColor = ColorTemplate.darkVistaBlue,
    this.fillColor = ColorTemplate.lavender,
    this.textColor = ColorTemplate.darkVistaBlue,
    this.maxLines = 1,
    this.isReadOnly = false,
    this.isRequired = true,
    this.initialValue,
    this.controller,
    this.inputFormatters,
    this.validator = defaultValidator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  static String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong isi inputan ini';
    }
    return null;
  }

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: dynamicPaddingSymmetric(0, 20, context),
          child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: widget.title,
                  style: TextStyle(
                    fontSize: dynamicFontSize(16, context),
                    fontWeight: FontWeight.w700,
                    color: widget.titleColor,
                  ),
                  children: widget.isRequired
                      ? <TextSpan>[
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ]
                      : <TextSpan>[],
                ),
              )),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        TextFormField(
          initialValue: widget.initialValue,
          controller: widget.controller,
          validator: widget.isRequired ? widget.validator : null,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          readOnly: widget.isReadOnly,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
            fontSize: dynamicFontSize(16, context),
            color: widget.isReadOnly ? Colors.grey[600] : widget.textColor,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            contentPadding: dynamicPaddingSymmetric(16, 24, context),
            enabledBorder: _outlineInputBorder(context),
            focusedBorder: _outlineInputBorder(context),
            errorBorder: _errorOutlineInputBorder(context),
            // Customize error border
            focusedErrorBorder: _errorOutlineInputBorder(context),
            // Customize focused error border
            filled: true,
            fillColor: widget.fillColor,
            focusColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder _outlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.circular(25.0), // Set a consistent border radius
  );
}

OutlineInputBorder _errorOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.red, // Customize error border color as needed
    ),
    borderRadius: BorderRadius.circular(25.0), // Set a consistent border radius
  );
}
