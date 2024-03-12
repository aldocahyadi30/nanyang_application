import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendanceLabor.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceLaborListtile extends StatefulWidget {
  final AttendanceLaborModel model;

  const AttendanceLaborListtile({super.key, required this.model});

  @override
  State<AttendanceLaborListtile> createState() => _AttendanceLaborListtileState();
}

class _AttendanceLaborListtileState extends State<AttendanceLaborListtile> {
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
        onTap: () {
          Navigator.pushNamed(context, '/absensi/detail', arguments: widget.model);
        },
      ),
    );
  }
}
