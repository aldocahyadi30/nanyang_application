import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/size.dart';

class FormButton extends StatefulWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double buttonHeight;
  final double textSize;
  final String text;
  final bool isLoading;
  final double elevation;
  final void Function() onPressed;
  const FormButton(
      {super.key,
      this.backgroundColor = ColorTemplate.violetBlue,
      this.foregroundColor = Colors.white,
      this.textColor = Colors.white,
      this.buttonHeight = 64,
      this.textSize = 16,
      required this.text,
      required this.isLoading,
      this.elevation = 0,
      required this.onPressed});

  @override
  State<FormButton> createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: dynamicHeight(widget.buttonHeight, context),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: widget.elevation,
          ),
          child: widget.isLoading
              ? CircularProgressIndicator(color: widget.textColor) // Show CircularProgressIndicator when _isLoading is true
              : Text(
                  widget.text,
                  style: TextStyle(fontSize: dynamicFontSize(widget.textSize, context), color: widget.textColor, fontWeight: FontWeight.bold),
                )),
    );
  }
}
