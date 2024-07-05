import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';

class DashboardMenuIcon extends StatelessWidget {
  final String image;
  final String title;
  final Function? onTap;

  const DashboardMenuIcon({super.key, required this.image, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: dynamicWidth(100, context),
        height: dynamicHeight(80, context),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: dynamicWidth(52, context), height: dynamicHeight(52, context)),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: dynamicFontSize(12, context), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}