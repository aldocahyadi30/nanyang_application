import 'package:flutter/material.dart';

class NanyangHeader extends StatelessWidget {
  final String title;

  const NanyangHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}