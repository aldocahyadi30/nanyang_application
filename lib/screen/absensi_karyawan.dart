import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/attendance_date_provider.dart';
import 'package:nanyang_application/widget/absensi_list.dart';
import 'package:nanyang_application/widget/absensi_datepicker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AbsensiKaryawanScreen extends StatefulWidget {
  const AbsensiKaryawanScreen({super.key});

  @override
  State<AbsensiKaryawanScreen> createState() => _AbsensiKaryawanScreenState();
}

class _AbsensiKaryawanScreenState extends State<AbsensiKaryawanScreen> {
  final TextEditingController _dateController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AbsensiDatePicker(controller: _dateController),
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
          const Expanded(child: AbsensiList(mode: 'karyawan',))
        ],
      ),
    );
  }
}
