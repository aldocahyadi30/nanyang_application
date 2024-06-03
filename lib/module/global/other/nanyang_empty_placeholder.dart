import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nanyang_application/helper.dart';

class NanyangEmptyPlaceholder extends StatelessWidget {
  const NanyangEmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/empty_2.svg',
          semanticsLabel: 'Empty Logo',
          width: dynamicWidth(100, context),
          height: dynamicHeight(100, context),
        ),
        SizedBox(
          height: dynamicHeight(16, context),
        ),
        Text('Tidak ada data', style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(16, context))),
      ],
    );
  }
}