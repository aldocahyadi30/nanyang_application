import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nanyang_application/model/attendance_labor.dart';

class AbsensiCabutanListtile extends StatefulWidget {
  final AttendanceLaborModel model;

  const AbsensiCabutanListtile({super.key, required this.model});

  @override
  State<AbsensiCabutanListtile> createState() => _AbsensiCabutanListtileState();
}

class _AbsensiCabutanListtileState extends State<AbsensiCabutanListtile> {
  @override
  Widget build(BuildContext context) {
    List<String> nameParts = widget.model.employeeName.split(' ');
    String avatarText = ((nameParts.isNotEmpty ? nameParts[0][0] : '') +
            (nameParts.length > 1 ? nameParts[1][0] : ''))
        .toUpperCase();

    String employeeName = '';
    if (nameParts.length == 1) {
      employeeName = nameParts[0];
    } else if (nameParts.length == 2) {
      employeeName =
          nameParts.join(' ');
    } else {
      employeeName = nameParts.take(2).join(' ') +
          nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
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
          radius: 30,
          backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
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
        
        
      ),
    );
  }
}
