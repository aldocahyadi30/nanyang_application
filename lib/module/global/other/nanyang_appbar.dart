import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/size.dart';

class NanyangAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  final bool isCenter;
  final Color backgroundColor;
  final List<Widget> actions;

  const NanyangAppbar({super.key, required this.title, this.isBackButton = false, this.isCenter = false, this.backgroundColor = Colors.transparent,this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Text(
        title,
        style:  TextStyle(color: ColorTemplate.violetBlue, fontSize: dynamicFontSize(32, context), fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      automaticallyImplyLeading: isBackButton,
      centerTitle: isCenter,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}