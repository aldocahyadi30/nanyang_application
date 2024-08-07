import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:nanyang_application/model/attendance_detail.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceAdminCard extends StatefulWidget {
  final AttendanceAdminModel model;

  const AttendanceAdminCard({super.key, required this.model});

  @override
  State<AttendanceAdminCard> createState() => _AttendanceAdminCardState();
}

class _AttendanceAdminCardState extends State<AttendanceAdminCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorTemplate.violetBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: dynamicPaddingSymmetric(8, 16, context),
        leading: CircleAvatar(
          radius: dynamicWidth(24, context),
          backgroundColor: ColorTemplate.argentinianBlue,
          child: Text(
            widget.model.employee.initials!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Padding(
          padding: dynamicPaddingOnly(0, 4, 0, 0, context),
          child: Text(
            widget.model.employee.shortedName!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        subtitle: widget.model.employee.position.type == 1
            ? _buildSubWorker(context, widget.model.attendance!)
            : _buildSubLabor(context, widget.model.laborDetail!),
        trailing: widget.model.employee.position.type == 1
            ? _buildTrailing(context, 1)
            : _buildTrailing(context, 2, detailID: widget.model.laborDetail!.id),
        onTap: () async => context.read<AttendanceViewModel>().detail(widget.model),
      ),
    );
  }

  Row _buildSubWorker(BuildContext context, AttendanceModel attendance) {
    if (attendance.id != 0) {
      int? inStatus = attendance.inStatus;
      int? outStatus = attendance.outStatus;
      DateTime? checkIn = attendance.checkIn;
      DateTime? checkOut = attendance.checkOut;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildStatusWorker(context, 0, inStatus: inStatus, checkIn: checkIn)),
          Expanded(child: _buildStatusWorker(context, 1, outStatus: outStatus, checkOut: checkOut)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildStatusWorker(context, 0)),
          Expanded(child: _buildStatusWorker(context, 1)),
        ],
      );
    }
  }

  Row _buildStatusWorker(BuildContext context, int type,
      {int? inStatus, int? outStatus, DateTime? checkIn, DateTime? checkOut}) {
    Color color = const Color(0xFFFF8D8D);
    String time = '-';

    if (type == 0 && inStatus != null && checkIn != null) {
      time = DateFormat('HH:mm').format(checkIn);
      if (inStatus == 1) {
        color = const Color(0xFF94EE8C);
      } else if (inStatus == 2) {
        time = "$time (Telat)";
        color = const Color(0xFFFFE485);
      }
    } else if (type == 1 && outStatus != null && checkOut != null) {
      time = DateFormat('HH:mm').format(checkOut);
      if (outStatus == 1) {
        color = const Color(0xFF94EE8C);
      }
    }
    return Row(
      children: [
        Row(
          children: [
            Icon(type == 0 ? Icons.location_on : Icons.wrong_location, color: color),
            SizedBox(width: dynamicWidth(4, context)),
            Text(
              time,
              style: TextStyle(
                fontSize: dynamicFontSize(12, context),
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }

  Text _buildSubLabor(BuildContext context, AttendanceDetailModel detail) {
    if (detail.id != 0) {
      return Text(
        'Absensi terisi',
        style: TextStyle(
          fontSize: dynamicFontSize(12, context),
          color: const Color(0xFF94EE8C),
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return Text(
        'Absensi belum terisi',
        style: TextStyle(
          fontSize: dynamicFontSize(12, context),
          color: const Color(0xFFFF8D8D),
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget _buildTrailing(BuildContext context, int type, {int detailID = 0}) {
    if (type == 1) {
      return Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: dynamicWidth(16, context),
      );
    } else {
      if (detailID != 0) {
        return const CircleAvatar(
          backgroundColor: Colors.green,
          child: FaIcon(
            FontAwesomeIcons.check,
            color: Colors.white,
          ),
        );
      } else {
        return const CircleAvatar(
          backgroundColor: Colors.red,
          child: FaIcon(
            FontAwesomeIcons.x,
            color: Colors.white,
          ),
        );
      }
    }
  }
}