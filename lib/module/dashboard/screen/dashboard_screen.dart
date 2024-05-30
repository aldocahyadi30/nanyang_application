import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_admin.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_announcement.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_profile_card.dart';
import 'package:nanyang_application/module/dashboard/widget/dashboard_request.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ConfigurationProvider config;

  @override
  void initState() {
    super.initState();
    config = context.read<ConfigurationProvider>();

    if (config.isAdmin){
      context.read<EmployeeViewModel>().getCount();
      context.read<AttendanceViewModel>().getCount();
    }else{
      context.read<AnnouncementViewModel>().getDashboardAnnouncement();
    }
    context.read<RequestViewModel>().getDashboardRequest();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      body: RefreshIndicator(
        onRefresh: () async {
          if (config.isAdmin){
            context.read<EmployeeViewModel>().getCount();
            context.read<AttendanceViewModel>().getCount();
          }else{
            context.read<AnnouncementViewModel>().getDashboardAnnouncement();
          }
          context.read<RequestViewModel>().getDashboardRequest();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(72),
                      bottomRight: Radius.circular(72),
                    ),
                    color: ColorTemplate.violetBlue,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: dynamicHeight(72, context),
                  ),
                  const DashboardProfileCard(),
                  SizedBox(
                    height: dynamicHeight(8, context),
                  ),
                  config.isAdmin ? const DashboardAdmin() : const DashboardAnnouncement(),
                  SizedBox(
                    height: dynamicHeight(8, context),
                  ),
                  const DashboardRequest(),
                  SizedBox(
                    height: dynamicHeight(8, context),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}