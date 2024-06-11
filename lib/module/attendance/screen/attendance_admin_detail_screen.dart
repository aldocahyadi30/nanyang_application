import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_admin_form.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';

class AttendanceAdminDetailScreen extends StatefulWidget {
  const AttendanceAdminDetailScreen({super.key});

  @override
  State<AttendanceAdminDetailScreen> createState() => _AttendanceAdminDetailScreenState();
}

class _AttendanceAdminDetailScreenState extends State<AttendanceAdminDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(title: 'Absensi', isBackButton: true, isCenter: true),
      body: Container(
        // height: double.infinity,
        padding: dynamicPaddingSymmetric(8, 16, context),
        child: const SingleChildScrollView(
          child: AttendanceAdminForm(),
        ),
      ),
    );
  }
}