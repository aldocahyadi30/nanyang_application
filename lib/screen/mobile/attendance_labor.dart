import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/attendance_list.dart';
import 'package:nanyang_application/widget/datepicker.dart';

class AttendanceLaborScreen extends StatefulWidget {
  const AttendanceLaborScreen({super.key});

  @override
  State<AttendanceLaborScreen> createState() => _AttendanceLaborScreenState();
}

class _AttendanceLaborScreenState extends State<AttendanceLaborScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController();
    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      dateController.dispose();
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Datepicker(controller: dateController, type: 'attendance-labor'),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Daftar Absensi Cabutan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: AttendanceList(mode: 'cabutan'),
          )
        ],
      ),
    );
  }
}
