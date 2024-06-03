import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nanyang_application/helper.dart';

class NanyangNoAccessPlaceholder extends StatelessWidget {
  const NanyangNoAccessPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/no_access.svg',
          semanticsLabel: 'No Access Logo',
          width: dynamicWidth(100, context),
          height: dynamicHeight(100, context),
        ),
        SizedBox(
          height: dynamicHeight(16, context),
        ),
        Text('Anda tidak memiliki akses!', style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(16, context))),
      ],
    );
  }
}