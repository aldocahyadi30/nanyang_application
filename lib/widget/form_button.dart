import 'package:flutter/material.dart';

class FormButton extends StatefulWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final String? text;
  final bool? isLoading;
  final void Function()? onPressed;
  const FormButton(
      {super.key,
      this.backgroundColor,
      this.foregroundColor,
      this.textColor,
      this.text,
      this.isLoading,
      this.onPressed});

  @override
  State<FormButton> createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.0,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: widget.isLoading!
            ? CircularProgressIndicator(
                color: widget.textColor) // Show CircularProgressIndicator when _isLoading is true
            : Text(
                widget.text!,
                style: TextStyle(fontSize: 18.0, color: widget.textColor),
              )
      ),
    );
  }
}
