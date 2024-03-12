import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendanceWorker.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceWorkerListtile extends StatefulWidget {
  final AttendanceWorkerModel model;
  const AttendanceWorkerListtile({super.key, required this.model});

  @override
  State<AttendanceWorkerListtile> createState() =>
      _AttendanceWorkerListtileState();
}

class _AttendanceWorkerListtileState extends State<AttendanceWorkerListtile> {
  @override
  Widget build(BuildContext context) {
    String avatarText = Provider.of<AttendanceViewModel>(context)
        .getAvatarInitials(widget.model.employeeName);
    String employeeName = Provider.of<AttendanceViewModel>(context)
        .getShortenedName(widget.model.employeeName);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor:
              Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Text(
            avatarText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          employeeName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: widget.model.status == 1
            ? Text(
                'Masuk: ${widget.model.time}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
            : const Text(
                'Tidak Hadir',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
        trailing: widget.model.status == 1
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
