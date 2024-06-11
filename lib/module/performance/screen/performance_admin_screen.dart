import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';

class PerformanceAdminScreen extends StatefulWidget {
  const PerformanceAdminScreen({super.key});

  @override
  State<PerformanceAdminScreen> createState() => _PerformanceAdminScreenState();
}

class _PerformanceAdminScreenState extends State<PerformanceAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Performa',
        isBackButton: true,
        isCenter: true,
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Peforma Produksi',
                  style: TextStyle(
                    fontSize: dynamicFontSize(20, context),
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
             
              SizedBox(height: dynamicHeight(16, context)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Absensi Karyawan',
                  style: TextStyle(
                    fontSize: dynamicFontSize(20, context),
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              SizedBox(height: dynamicHeight(16, context)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Absensi Karyawan Cabutan',
                  style: TextStyle(
                    fontSize: dynamicFontSize(20, context),
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}