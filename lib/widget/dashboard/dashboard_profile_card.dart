import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_menu_card.dart';
import 'package:provider/provider.dart';

class DashboardProfileCard extends StatelessWidget {
  const DashboardProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String avatarText = Provider.of<UserProvider>(context).avatarInitials!;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: dynamicHeight(250, context), // Set your desired height here
          child: const DashboardMenuCard(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0,
          child: Column(
            children: [
              Text(
                user != null ? user.positionName : '',
                style: TextStyle(
                  color: ColorTemplate.secondaryColor,
                  fontSize: dynamicFontSize(24, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: dynamicHeight(8, context),
              ),
              CircleAvatar(
                radius: dynamicWidth(48, context),
                backgroundColor: Colors.black,
                child: Text(
                  avatarText,
                  style:  TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}