import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/widget/attendance/attendance_card.dart';
import 'package:provider/provider.dart';

class AttendanceList extends StatefulWidget {
  final String mode;

  const AttendanceList({super.key, required this.mode});

  @override
  State<AttendanceList> createState() => _AttendanceListListState();
}

class _AttendanceListListState extends State<AttendanceList> {
  late final AttendanceViewModel _attendanceViewModel;
  late DateProvider _dateProvider;

  @override
  void initState() {
    super.initState();
    _attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: false);


  }

  @override
  Widget build(BuildContext context) {
    _dateProvider = Provider.of<DateProvider>(context);
    String date = widget.mode == 'labor'
        ? _dateProvider.attendanceLaborDateString
        : _dateProvider.attendanceWorkerDateString;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder(
        future: widget.mode == 'labor'
            ? _attendanceViewModel.getLaborAttendance(date)
            : _attendanceViewModel.getWorkerAttendance(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // showToast('Gagal mengambil data', 'error');
            return const Center(
              child: Text('Terjadi kesalahan saat memuat data. Silahkan coba lagi.'),
            );
          } else {
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(
                child: Text('Tidak ada data'),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index] is AttendanceLaborModel && widget.mode == 'labor') {
                    return AttendanceCard(labor: snapshot.data![index] as AttendanceLaborModel);
                  } else if (snapshot.data![index] is AttendanceWorkerModel && widget.mode == 'worker') {
                    return AttendanceCard(worker: snapshot.data![index] as AttendanceWorkerModel);
                  }
                  return Container(); // Add a return statement to return a default Container widget.
                },
              );
            }
          }
        },
      ),
    );
  }
}