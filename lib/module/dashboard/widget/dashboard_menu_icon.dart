import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';

class DashboardMenuIcon extends StatelessWidget {
  final String image;
  final Widget route;
  final String title;

  const DashboardMenuIcon({super.key, required this.image, required this.route, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
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