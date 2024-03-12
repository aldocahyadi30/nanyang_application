import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/attendance_list.dart';
import 'package:nanyang_application/widget/datepicker.dart';

class AttendanceWorkerScreen extends StatefulWidget {
  const AttendanceWorkerScreen({super.key});

  @override
  State<AttendanceWorkerScreen> createState() => _AttendanceWorkerScreenState();
}

class _AttendanceWorkerScreenState extends State<AttendanceWorkerScreen> {
  final TextEditingController dateController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Datepicker(controller: dateController, type: 'attendance-worker'),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Daftar Absensi Karyawan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
              child: AttendanceList(
            mode: 'karyawan',
          ))
        ],
      ),
    );
  }
}
