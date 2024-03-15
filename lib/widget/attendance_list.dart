import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/model/attendance_worker.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/widget/attendance_labor_listtile.dart';
import 'package:nanyang_application/widget/attendance_worker_listtile.dart';
import 'package:provider/provider.dart';

class AttendanceList extends StatefulWidget {
  final String mode;
  const AttendanceList({super.key, required this.mode});

  @override
  State<AttendanceList> createState() => _AbsensiKaryawanListState();
}

class _AbsensiKaryawanListState extends State<AttendanceList> {
  late final AttendanceViewModel _attendanceViewModel;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
    // initToast(context);
  }

  @override
  Widget build(BuildContext context) {
    // String date = Provider.of<AttendanceDateProvider>(context).formattedDate;
    String date = widget.mode == 'cabutan'
        ? Provider.of<DateProvider>(context).attendanceLaborDateString
        : Provider.of<DateProvider>(context).attendanceWorkerDateString;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder(
        future: widget.mode == 'cabutan'
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
              child: Text(
                  'Terjadi kesalahan saat memuat data. Silahkan coba lagi.'),
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
                  if (snapshot.data![index] is AttendanceLaborModel &&
                      widget.mode == 'cabutan') {
                    return AttendanceLaborListtile(
                        model: snapshot.data![index] as AttendanceLaborModel);
                  } else if (snapshot.data![index] is AttendanceWorkerModel &&
                      widget.mode == 'karyawan') {
                    return AttendanceWorkerListtile(
                        model: snapshot.data![index] as AttendanceWorkerModel);
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
