import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/model/attendanceLabor.dart';
import 'package:nanyang_application/widget/absensi_detail_form.dart';

class AbsensiDetailScreen extends StatefulWidget {
  const AbsensiDetailScreen({super.key});

  @override
  State<AbsensiDetailScreen> createState() => _AbsensiDetailScreenState();
}

class _AbsensiDetailScreenState extends State<AbsensiDetailScreen> {
  late Future<AttendanceLaborModel> futureModel = initializeModel();

  Future<AttendanceLaborModel> initializeModel() async {
    AttendanceLaborModel model =
        ModalRoute.of(context)!.settings.arguments as AttendanceLaborModel;

    return model;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Absensi',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: futureModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // handle the error
                  return Text('Error: ${snapshot.error}');
                } else {
                  return AbsensiDetailForm(
                      model: snapshot.data as AttendanceLaborModel);
                }
              }),
        ),
      ),
    );
  }
}
