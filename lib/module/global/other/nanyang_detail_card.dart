import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';

class NanyangDetailCard extends StatelessWidget {
  final String title;
  final List<Widget>? children;
  const NanyangDetailCard({super.key, required this.title, this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: dynamicPaddingSymmetric(16, 16, context),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: dynamicFontSize(20, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: dynamicHeight(16, context)),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
