import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance_labor.dart';
import 'package:nanyang_application/screen/mobile/attendance/attendance_worker.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          'Absensi',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[200]!,
                Colors.blue,
                Colors.blue[700]!,
                Colors.blue[800]!
              ],
            ),
          ),
        ),
        elevation: 4,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Karyawan',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Pekerja Cabutan',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [AttendanceWorkerScreen(), AttendanceLaborScreen()],
      ),
    );
  }
}