import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/size.dart';

class DashboardMenuIcon extends StatelessWidget {
  final String image;
  final Widget route;
  final String title;

  const DashboardMenuIcon({Key? key, required this.image, required this.route, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Container(
        width: dynamicWidth(88, context),
        height: dynamicHeight(88, context),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: dynamicWidth(52, context), height: dynamicHeight(52, context)),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: dynamicFontSize(10, context), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}