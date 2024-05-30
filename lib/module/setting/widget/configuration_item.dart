import 'package:flutter/material.dart';

class ConfigurationItem extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ConfigurationItem(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
          ),
        ]);
  }
}