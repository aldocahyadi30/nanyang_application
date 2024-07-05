import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendance_user.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_labor_card.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_worker_card.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceUserList extends StatefulWidget {
  const AttendanceUserList({super.key});

  @override
  State<AttendanceUserList> createState() => _AttendanceUserListState();
}

class _AttendanceUserListState extends State<AttendanceUserList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthViewModel>(context).user;
    return Padding(
      padding: dynamicPaddingSymmetric(0, 16, context),
      child: Selector<AttendanceViewModel, List<AttendanceUserModel>>(
        selector: (context, viewmodel) => viewmodel.attendanceUser,
        builder: (context, attendanceUser, child) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AttendanceViewModel>().getUserAttendance();
            },
            child: attendanceUser.isEmpty
                ? const NanyangEmptyPlaceholder()
                : ListView.builder(
                    itemCount: attendanceUser.length,
                    itemBuilder: (context, index) {
                      return user.employee.position.type == 1
                          ? AttendanceWorkerCard(attendance: attendanceUser[index])
                          : AttendanceLaborCard(attendance: attendanceUser[index]);
                    },
                  ),
          );
        },
      ),
    );
  }
}