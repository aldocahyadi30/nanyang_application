import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_menu_card.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:provider/provider.dart';

class DashboardProfileCard extends StatelessWidget {
  const DashboardProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final _config = Provider.of<ConfigurationProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: dynamicPaddingSymmetric(0, 16, context),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: dynamicHeight(250, context), // Set your desired height here
            child: const DashboardMenuCard(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.025,
            child: Column(
              children: [
                Text(
                  _config.user.positionName,
                  style: TextStyle(
                    color: ColorTemplate.periwinkle,
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
                    _config.avatarInitials,
                    style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
