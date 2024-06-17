import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';

class FormPickerField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final Color titleColor;
  final Color fillColor;
  final Widget picker;
  final Widget? leading;
  final bool isRequired;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool isDisabled;

  const FormPickerField({
    super.key,
    this.title,
    this.hintText,
    this.titleColor = ColorTemplate.darkVistaBlue,
    this.fillColor = ColorTemplate.lavender,
    required this.picker,
    this.isRequired = true,
    required this.controller,
    this.leading,
    this.validator = defaultValidator,
    this.isDisabled = false,
  });

  static String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong isi inputan ini';
    }
    return null;
  }

  @override
  State<FormPickerField> createState() => _FormPickerFieldState();
}

class _FormPickerFieldState extends State<FormPickerField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title != null)
          Column(
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
                  ),
                ),
              ),
              SizedBox(
                height: dynamicHeight(8, context),
              ),
            ],
          ),
        TextFormField(
          controller: widget.controller,
          validator: widget.isRequired ? widget.validator : null,
          readOnly: true,
          style: TextStyle(
            fontSize: dynamicFontSize(16, context),
            color: widget.isDisabled ? Colors.grey : ColorTemplate.darkVistaBlue,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: dynamicPaddingSymmetric(16, 24, context),
            enabledBorder: _outlineInputBorder(context),
            focusedBorder: _outlineInputBorder(context),
            errorBorder: _errorOutlineInputBorder(context),
            focusedErrorBorder: _errorOutlineInputBorder(context),
            filled: true,
            fillColor: widget.fillColor,
            focusColor: Colors.blue,
            suffixIcon: widget.picker,
            prefixIcon: widget.leading,
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