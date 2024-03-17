import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceCard extends StatefulWidget {
  final AttendanceWorkerModel? worker;
  final AttendanceLaborModel? labor;

  const AttendanceCard({super.key, this.worker, this.labor});

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  @override
  Widget build(BuildContext context) {
    late String avatarText;
    late String employeeName;

    if (widget.worker != null) {
      avatarText = Provider.of<AttendanceViewModel>(context)
          .getAvatarInitials(widget.worker!.employeeName);
      employeeName = Provider.of<AttendanceViewModel>(context)
          .getShortenedName(widget.worker!.employeeName);
    } else {
      avatarText = Provider.of<AttendanceViewModel>(context)
          .getAvatarInitials(widget.labor!.employeeName);
      employeeName = Provider.of<AttendanceViewModel>(context)
          .getShortenedName(widget.labor!.employeeName);
    }
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Text(
            avatarText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            employeeName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: widget.worker != null
            ? widget.worker!.status == 1
                ? Row(children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.worker!.time!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ])
                : const Text(
                    'Tidak Hadir',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  )
            : widget.labor!.status == 1
                ? const Text(
                    'Absensi terisi',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : const Text(
                    'Absensi belum terisi',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
        trailing: widget.worker != null
            ? widget.worker!.status == 1
                ? CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.red[100],
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  )
            : widget.labor!.status == 1
                ? CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.red[100],
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
      ),
    );
  }
}