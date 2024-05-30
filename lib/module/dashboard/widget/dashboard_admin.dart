import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: dynamicWidth(24, context),
          ),
          Container(
            width: dynamicWidth(275, context),
            height: dynamicHeight(100, context),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4539c2), Color(0xFF1a156b)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.8],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Consumer2<EmployeeViewModel, AttendanceViewModel>(
                builder: (context, employee, attendance, child) {
                  return RichText(
                    text: TextSpan(
                      text: attendance.workerCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dynamicFontSize(48, context),
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' /',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dynamicFontSize(36, context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: employee.workerCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dynamicFontSize(24, context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              subtitle: Text(
                'Absensi Karyawan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dynamicFontSize(16, context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.building,
                color: Colors.white,
                size: dynamicWidth(48, context),
              ),
            ),
          ),
          SizedBox(
            width: dynamicWidth(16, context),
          ),
          Container(
            width: dynamicWidth(275, context),
            height: dynamicHeight(100, context),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFad0e8d), Color(0Xff7d00d1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Consumer2<EmployeeViewModel, AttendanceViewModel>(
                builder: (context, employee, attendance, child) {
                  return RichText(
                    text: TextSpan(
                      text: attendance.laborCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dynamicFontSize(48, context),
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' /',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dynamicFontSize(36, context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: employee.laborCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: dynamicFontSize(24, context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              subtitle: Text(
                'Absensi Cabutan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dynamicFontSize(16, context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.industry,
                color: Colors.white,
                size: dynamicWidth(48, context),
              ),
            ),
          ),
          SizedBox(
            width: dynamicWidth(24, context),
          ),
        ],
      ),
    );
  }
}