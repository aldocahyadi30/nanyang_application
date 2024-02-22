import 'package:flutter/material.dart';

class DashboardMenuIcon extends StatelessWidget {
  final String image;
  final String route;
  final String title;

  const DashboardMenuIcon(
      {Key? key, required this.image, required this.route, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: 88,
        height: 88,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 44, height: 44),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
