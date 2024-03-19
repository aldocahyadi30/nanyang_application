import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_menu_card.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_announcement.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_profile_bar.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_profile_card.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_request.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.secondaryColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(72),
                      bottomRight: Radius.circular(72),
                    ),
                    color: ColorTemplate.primaryColor,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  color: ColorTemplate.secondaryColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        const DashboardAnnouncement(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),

                        const DashboardRequest(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05, // Adjust this value to position the card
              left: 0,
              right: 0,
              child: Padding(
                padding: dynamicPadding(16, 16, 16, 16, context),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: const DashboardProfileCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}