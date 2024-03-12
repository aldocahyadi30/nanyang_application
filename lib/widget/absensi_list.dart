import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/model/attendanceLabor.dart';
import 'package:nanyang_application/model/attendanceWorker.dart';
import 'package:nanyang_application/provider/attendance_date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/widget/absensi_cabutan_listtile.dart';
import 'package:nanyang_application/widget/absensi_karyawan_listtile.dart';
import 'package:nanyang_application/widget/toast.dart';
import 'package:provider/provider.dart';

class AbsensiList extends StatefulWidget {
  final String mode;
  const AbsensiList({super.key, required this.mode});

  @override
  State<AbsensiList> createState() => _AbsensiKaryawanListState();
}

class _AbsensiKaryawanListState extends State<AbsensiList> {
  late final AttendanceViewModel _attendanceViewModel;
  late FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
    // initToast(context);
  }

  @override
  Widget build(BuildContext context) {
    String date = Provider.of<DateProvider>(context).date;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder(
        future: widget.mode == 'cabutan'
            ? _attendanceViewModel.getTodayLaborerAttendance(date)
            : _attendanceViewModel.getTodayWorkerAttendance(date),
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
                    return AbsensiCabutanListtile(
                        model: snapshot.data![index] as AttendanceLaborModel);
                  } else if (snapshot.data![index] is AttendanceWorkerModel &&
                      widget.mode == 'karyawan') {
                    return AbsensiKaryawanListtile(
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
