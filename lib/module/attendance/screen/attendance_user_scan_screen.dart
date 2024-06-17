import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_camera.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';

class AttendanceUserScanScreen extends StatefulWidget {
  const AttendanceUserScanScreen({super.key});

  @override
  State<AttendanceUserScanScreen> createState() => _AttendanceUserScanScreenState();
}

class _AttendanceUserScanScreenState extends State<AttendanceUserScanScreen> {
  bool isLocation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: NanyangAppbar(
        title: 'Absensi Scan',
        isBackButton: true,
        isCenter: true,
        actions: [
          Icon(isLocation ? Icons.location_on : Icons.location_off, color: isLocation ? Colors.green : Colors.red)
        ],
      ),
      body: Column(
        children: [
          const Expanded(flex: 3, child: AttendanceCamera()),
          Expanded(
            flex: 1,
            child: Container(
              padding: dynamicPaddingSymmetric(8, 16, context),
              child: Column(
                children: [
                  Text(
                    'Scan QR Code untuk Absen',
                    style: TextStyle(
                      fontSize: dynamicFontSize(16, context),
                      fontWeight: FontWeight.w700,
                      color: ColorTemplate.violetBlue,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Pastikan wajah terlihat jelas',
                    style: TextStyle(
                      fontSize: dynamicFontSize(14, context),
                      fontWeight: FontWeight.w400,
                      color: ColorTemplate.violetBlue,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
