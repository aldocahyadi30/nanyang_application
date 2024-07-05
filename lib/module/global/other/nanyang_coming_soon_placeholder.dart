import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';

class NanyangComingSoonPlaceholder extends StatelessWidget {
  final String title;

  const NanyangComingSoonPlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: NanyangAppbar(
        title: title,
        isCenter: true,
        isBackButton: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/svg/coming_soon.svg',
              semanticsLabel: 'Coming Soon Logo',
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          ),
          SizedBox(
            height: dynamicHeight(16, context),
          ),
          Text('Fitur akan hadir!', style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context),fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}