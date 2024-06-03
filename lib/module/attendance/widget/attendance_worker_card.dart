import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/attendance_user.dart';
import 'package:nanyang_application/helper.dart';

class AttendanceWorkerCard extends StatefulWidget {
  final AttendanceUserModel user;

  const AttendanceWorkerCard({super.key, required this.user});

  @override
  State<AttendanceWorkerCard> createState() => _AttendanceWorkerCardState();
}

class _AttendanceWorkerCardState extends State<AttendanceWorkerCard> {
  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEEE, dd MMMM yyyy').format(widget.user.date);
    return Column(
      children: [
        Padding(
          padding: dynamicPaddingSymmetric(0, 20, context),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              date,
              style: TextStyle(
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w700,
                color: ColorTemplate.violetBlue,
              ),
            ),
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorTemplate.violetBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              _buildCheckIn(context, widget.user),
              const Divider(
                color: Color(0xFFC0C9FF),
                thickness: 0.1,
                height: 0,
              ),
              _buildCheckOut(context, widget.user),
            ],
          ),
        ),
        SizedBox(
          height: dynamicHeight(20, context),
        ),
      ],
    );
  }
}

Widget _buildCheckIn(BuildContext context, AttendanceUserModel data) {
  return ListTile(
    contentPadding: dynamicPaddingSymmetric(0, 16, context),
    leading: const Icon(Icons.login, color: Color(0xFFC2FFC2)),
    title: Text(
      'Check-in',
      style: TextStyle(
        color: Colors.white,
        fontSize: dynamicFontSize(16, context),
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: _checkInSub(context, data.attendance?['inStatus'], data.attendance?['checkIn']),
    trailing: _buildTrailing(context, data.attendance?['inStatus']),
  );
}

Widget _buildCheckOut(BuildContext context, AttendanceUserModel data) {
  return ListTile(
    contentPadding: dynamicPaddingSymmetric(0, 16, context),
    leading: const Icon(Icons.logout, color: Color(0xFFFC9797)),
    title: Text(
      'Check-out',
      style: TextStyle(
        color: Colors.white,
        fontSize: dynamicFontSize(16, context),
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: _buildCheckOutSub(context, data.attendance?['outStatus'], data.attendance?['checkOut']),
    trailing: _buildTrailing(context, data.attendance?['outStatus']),
  );
}

Widget _checkInSub(BuildContext context, int status, DateTime? time) {
  if (status == 0) {
    return Text(
      'Belum Melakukan Absensi',
      style: TextStyle(
        color: ColorTemplate.periwinkle,
        fontSize: dynamicFontSize(12, context),
        fontWeight: FontWeight.w500,
      ),
    );
  } else if (status == 1) {
    return Row(
      children: [
        Text(
          'Absen Masuk',
          style: TextStyle(
            color: ColorTemplate.periwinkle,
            fontSize: dynamicFontSize(12, context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: dynamicWidth(4, context),
        ),
        FaIcon(
          FontAwesomeIcons.solidClock,
          color: ColorTemplate.periwinkle,
          size: dynamicFontSize(12, context),
        ),
        SizedBox(
          width: dynamicWidth(4, context),
        ),
        Text(
          DateFormat('H:mm').format(time!),
          style: TextStyle(
            color: ColorTemplate.lightVistaBlue,
            fontSize: dynamicFontSize(12, context),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  } else {
    return Row(
      children: [
        Text(
          'Absen Masuk (Telat)',
          style: TextStyle(
            color: ColorTemplate.periwinkle,
            fontSize: dynamicFontSize(12, context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: dynamicWidth(4, context),
        ),
        FaIcon(
          FontAwesomeIcons.solidClock,
          color: ColorTemplate.periwinkle,
          size: dynamicFontSize(12, context),
        ),
        SizedBox(
          width: dynamicWidth(4, context),
        ),
        Text(
          DateFormat('H:mm').format(time!),
          style: TextStyle(
            color: ColorTemplate.lightVistaBlue,
            fontSize: dynamicFontSize(12, context),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

Widget _buildCheckOutSub(BuildContext context, int status, DateTime? time) {
  if (status == 0) {
    return Text(
      'Belum Melakukan Absensi',
      style: TextStyle(
        color: ColorTemplate.periwinkle,
        fontSize: dynamicFontSize(12, context),
        fontWeight: FontWeight.w500,
      ),
    );
  } else {
    return Row(
      children: [
        Text(
          'Absen Keluar',
          style: TextStyle(
            color: ColorTemplate.periwinkle,
            fontSize: dynamicFontSize(12, context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: dynamicWidth(4, context),
        ),
        FaIcon(
          FontAwesomeIcons.solidClock,
          color: ColorTemplate.periwinkle,
          size: dynamicFontSize(12, context),
        ),
        SizedBox(
          width: dynamicWidth(4, context),
        ),
        Text(
          DateFormat('HH:mm').format(time!),
          style: TextStyle(
            color: ColorTemplate.lightVistaBlue,
            fontSize: dynamicFontSize(12, context),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

Widget _buildTrailing(BuildContext context, int status) {
  if (status == 0) {
    return const CircleAvatar(
      backgroundColor: Colors.red,
      child: FaIcon(
        FontAwesomeIcons.x,
        color: Colors.white,
      ),
    );
  } else if (status == 1) {
    return const CircleAvatar(
      backgroundColor: Colors.green,
      child: FaIcon(
        FontAwesomeIcons.check,
        color: Colors.white,
      ),
    );
  } else {
    return const CircleAvatar(
      backgroundColor: Colors.yellow,
      child: FaIcon(
        FontAwesomeIcons.exclamation,
        color: Colors.black,
      ),
    );
  }
}