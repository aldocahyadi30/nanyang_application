import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';

class NanyangLoadingDialog extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  const NanyangLoadingDialog({super.key, this.backgroundColor = ColorTemplate.periwinkle, this.color = ColorTemplate.violetBlue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),

        child: Padding(
          padding: dynamicPaddingAll(16, context),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use as little space as possible
            children: <Widget>[
              Text(
                'Loading...',
                style: TextStyle(color: color, fontSize: dynamicFontSize(16, context)),
              ),
              SizedBox(height: dynamicHeight(16, context)), // Add a little padding
              CircularProgressIndicator(
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}