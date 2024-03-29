  import 'package:flutter/material.dart';
  import 'package:nanyang_application/widget/attendance/attendance_list.dart';
  import 'package:nanyang_application/widget/global/datepicker.dart';

  class AttendanceLaborScreen extends StatefulWidget {
    const AttendanceLaborScreen({super.key});

    @override
    State<AttendanceLaborScreen> createState() => _AttendanceLaborScreenState();
  }

  class _AttendanceLaborScreenState extends State<AttendanceLaborScreen> {
    final TextEditingController dateController = TextEditingController();

    @override
    void dispose() {
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Filter Tanggal',
                    labelStyle: const TextStyle(color: Colors.blue),
                    suffixIcon: Datepicker(
                      controller: dateController,
                      type: 'attendance-labor',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
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
              child: AttendanceList(mode: 'labor'),
            )
          ],
        ),
      );
    }
  }