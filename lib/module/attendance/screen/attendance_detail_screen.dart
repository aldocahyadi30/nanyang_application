import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_labor_detail_form.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final AttendanceLaborModel model;

  const AttendanceDetailScreen({super.key, required this.model});

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Absensi',
        isBackButton: true,
        isCenter: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        // padding: dynamicPaddingAll(16, context),
        child: SingleChildScrollView(
          child: AttendanceLaborDetailForm(model: widget.model),
        ),
      ),
    );
  }
}