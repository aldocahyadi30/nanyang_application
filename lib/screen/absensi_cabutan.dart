import 'package:flutter/material.dart';

class AbsensiCabutanScreen extends StatefulWidget {
  const AbsensiCabutanScreen({super.key});

  @override
  State<AbsensiCabutanScreen> createState() => _AbsensiCabutanScreenState();
}

class _AbsensiCabutanScreenState extends State<AbsensiCabutanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text('Absensi Cabutan'),
      ),
    );
  }
}
