import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_admin_card.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceAdminList extends StatefulWidget {
  final int type;

  const AttendanceAdminList({super.key, required this.type});

  @override
  State<AttendanceAdminList> createState() => _AttendanceAdminListState();
}

class _AttendanceAdminListState extends State<AttendanceAdminList> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceViewModel>().getAdminAttendance(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingSymmetric(0, 16, context),
      child: Selector<AttendanceViewModel, List<AttendanceAdminModel>>(
        selector: (context, viewmodel) => viewmodel.attendanceAdmin.where((element) => element.positionType == widget.type).toList(),
        builder: (context, attendanceAdmin, child) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AttendanceViewModel>().getAdminAttendance(widget.type);
            },
            child: attendanceAdmin.isEmpty
                ? const Center(child: NanyangEmptyPlaceholder())
                : ListView.builder(
                    itemCount: attendanceAdmin.length,
                    itemBuilder: (context, index) {
                      return AttendanceAdminCard(
                        model: attendanceAdmin[index],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
