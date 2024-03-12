import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/absensi_datepicker.dart';
import 'package:nanyang_application/widget/absensi_list.dart';

class AbsensiCabutanScreen extends StatefulWidget {
  const AbsensiCabutanScreen({super.key});

  @override
  State<AbsensiCabutanScreen> createState() => _AbsensiCabutanScreenState();
}

class _AbsensiCabutanScreenState extends State<AbsensiCabutanScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _dateController = TextEditingController();
    @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      _dateController.dispose();
      print(_dateController.text);
    }

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
              'Daftar Absensi Cabutan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
              child: AbsensiList(
            mode: 'cabutan',
          ))
        ],
      ),
    );
  }
}
