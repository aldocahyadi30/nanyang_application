import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';

class FormDropdown<T> extends StatefulWidget {
  final String title;
  final Color titleColor;
  final Color fillColor;
  final Color menuColor;
  final bool isRequired;
  final bool isReadOnly;
  final List<DropdownMenuItem<T?>> items;
  final T? value;
  final dynamic Function(dynamic)? onChanged;
  final String? Function(dynamic) validator;

  const FormDropdown({
    super.key,
    required this.title,
    this.titleColor = ColorTemplate.darkVistaBlue,
    this.fillColor = ColorTemplate.lavender,
    this.menuColor = ColorTemplate.lavender,
    this.isRequired = true,
    this.isReadOnly = false,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator = defaultValidator,
  });

  static String? defaultValidator(value) {
    if (value == null || value == 0 || value == '') {
      return 'Tolong isi inputan ini';
    }
    return null;
  }

  @override
  State<FormDropdown> createState() => _FormDropdownState();
}

class _FormDropdownState extends State<FormDropdown> {
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
                  children: widget.isRequired ? <TextSpan>[
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: dynamicFontSize(16, context),
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ] : <TextSpan>[],
                ),
              )
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        DropdownButtonFormField(
          items: widget.items,
          value: widget.value,
          onChanged: widget.isReadOnly ? null : widget.onChanged,
          validator: widget.isRequired ? widget.validator : null,
          menuMaxHeight: dynamicHeight(200, context),
          dropdownColor: widget.menuColor,
          iconEnabledColor: ColorTemplate.darkVistaBlue,
          isExpanded: true,
          style: TextStyle(
            fontSize: dynamicFontSize(16, context),
            color: ColorTemplate.darkVistaBlue,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            contentPadding: dynamicPaddingSymmetric(16, 24, context),
            enabledBorder: _outlineInputBorder(context),
            focusedBorder: _outlineInputBorder(context),
            errorBorder: _errorOutlineInputBorder(context),
            focusedErrorBorder: _errorOutlineInputBorder(context),
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