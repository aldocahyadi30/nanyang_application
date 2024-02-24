import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/attendance_date_provider.dart';
import 'package:nanyang_application/service/attendance_service.dart';
import 'package:nanyang_application/viewmodel/attedance_viewmodel.dart';
import 'package:nanyang_application/widget/absensi_karyawan_listtile.dart';
import 'package:provider/provider.dart';

class AbsensiKaryawanList extends StatefulWidget {
  const AbsensiKaryawanList({super.key});

  @override
  State<AbsensiKaryawanList> createState() => _AbsensiKaryawanListState();
}

class _AbsensiKaryawanListState extends State<AbsensiKaryawanList> {
  late final AttendanceViewModel _attendanceViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    String date = Provider.of<DateProvider>(context).date;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder(
        future: _attendanceViewModel.getTodayWorkerAttendance(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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
                  return AbsensiKaryawanListtile(model: snapshot.data![index]);
                },
              );
            }
          }
        },
      ),
    );
  }
}
