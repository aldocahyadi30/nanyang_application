import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/widget/pengumuman_create_form.dart';

class PengumumanCreateScreen extends StatefulWidget {
  const PengumumanCreateScreen({super.key});

  @override
  State<PengumumanCreateScreen> createState() => _PengumumanCreateScreenState();
}

class _PengumumanCreateScreenState extends State<PengumumanCreateScreen> {
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
          'Pengumuman',
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
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Form Pengumuman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PengumumanCreateForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
