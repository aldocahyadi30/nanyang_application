import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';

class PerformanceLaborDetailScreen extends StatefulWidget {
  const PerformanceLaborDetailScreen({super.key});

  @override
  State<PerformanceLaborDetailScreen> createState() => _PerformanceLaborDetailScreenState();
}

class _PerformanceLaborDetailScreenState extends State<PerformanceLaborDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Performa',
        isCenter: true,
        isBackButton: true,
      ),
      body: Container(),
    );
  }
}