import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/attendance/widget/attendance_admin_list.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceAdminScreen extends StatefulWidget {
  const AttendanceAdminScreen({super.key});

  @override
  State<AttendanceAdminScreen> createState() => _AttendanceAdminScreenState();
}

class _AttendanceAdminScreenState extends State<AttendanceAdminScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController workerController = TextEditingController();
  final TextEditingController laborController = TextEditingController();
  late DateTime date;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    date = context.read<AttendanceViewModel>().selectedAdminDate;
    workerController.text = parseDateToStringFormatted(date);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    workerController.dispose();
    laborController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'Absensi',
          style: TextStyle(
              color: ColorTemplate.violetBlue, fontSize: dynamicFontSize(32, context), fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Container(
            margin: dynamicMargin(0, 0, 16, 16, context),
            height: dynamicHeight(40, context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                25.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[600]!,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                color: ColorTemplate.darkVistaBlue,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: ColorTemplate.darkVistaBlue,
              tabs: const [
                Tab(
                  text: 'Karyawan',
                ),
                Tab(
                  text: 'Pekerja Cabutan',
                )
              ],
              dividerHeight: 0,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWorkerScreen(context, workerController, date),
          _buildLaborScreen(context, laborController, date)
        ],
      ),
    );
  }
}

Widget _buildWorkerScreen(BuildContext context, TextEditingController dateController, DateTime date) {
  return Column(
    children: [
      Padding(
        padding: dynamicPaddingAll(16, context),
        child: Container(
          padding: dynamicPaddingSymmetric(0, 10, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[600]!,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            readOnly: true,
            controller: dateController,
            decoration: InputDecoration(
              contentPadding: dynamicPaddingSymmetric(12, 16, context),
              labelText: 'Filter Tanggal',
              labelStyle: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
              suffixIcon: NanyangDatePicker(
                controller: dateController,
                color: ColorTemplate.violetBlue,
                selectedDate: date,
                onDatePicked: (picked) {
                  dateController.text = parseDateToStringFormatted(picked);
                  context.read<AttendanceViewModel>().selectedAdminDate = picked;
                  context.read<AttendanceViewModel>().getAdminAttendance();
                },
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      // SizedBox(height: dynamicHeight(8, context)),
      const Expanded(
        child: AttendanceAdminList(type: 1),
      )
    ],
  );
}

Widget _buildLaborScreen(BuildContext context, TextEditingController dateController, DateTime date) {
  return Column(
    children: [
      Padding(
        padding: dynamicPaddingAll(16, context),
        child: Container(
          padding: dynamicPaddingSymmetric(0, 10, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[600]!,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            readOnly: true,
            controller: dateController,
            decoration: InputDecoration(
              contentPadding: dynamicPaddingSymmetric(12, 16, context),
              labelText: 'Filter Tanggal',
              labelStyle: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
              suffixIcon: NanyangDatePicker(
                controller: dateController,
                color: ColorTemplate.violetBlue,
                selectedDate: date,
                onDatePicked: (picked) {
                  dateController.text = parseDateToStringFormatted(picked);
                  context.read<AttendanceViewModel>().selectedAdminDate = picked;
                  context.read<AttendanceViewModel>().getAdminAttendance();
                },
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      // SizedBox(height: dynamicHeight(8, context)),
      const Expanded(
        child: AttendanceAdminList(type: 2),
      ),
    ],
  );
}