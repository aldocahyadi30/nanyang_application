import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/model/attendanceLabor.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:nanyang_application/widget/toast.dart';
import 'package:provider/provider.dart';

class AttendanceLaborDetailForm extends StatefulWidget {
  final AttendanceLaborModel model;
  const AttendanceLaborDetailForm({super.key, required this.model});

  @override
  State<AttendanceLaborDetailForm> createState() => _AttendanceLaborDetailFormState();
}

enum AttendanceStatus { tugasBaru, tugasLanjut, tidakHadir }

class _AttendanceLaborDetailFormState extends State<AttendanceLaborDetailForm> {
  int? radioValue;
  AttendanceStatus? _attendanceStatus;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _initialQtyController = TextEditingController();
  final TextEditingController _finalQtyController = TextEditingController();
  final TextEditingController _initialWeightController =
      TextEditingController();
  final TextEditingController _finalWeightController = TextEditingController();
  final TextEditingController _cleanlinessController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FToast fToast;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initToast(context);
    _dateController.text = Provider.of<DateProvider>(context, listen: false).attendanceLaborDateString;

    radioValue = widget.model.type;
    if (widget.model.status == 1) {
      _attendanceStatus = AttendanceStatus.tugasBaru;
      _initialQtyController.text = widget.model.initialQty.toString();
      _finalQtyController.text = widget.model.finalQty.toString();
      _initialWeightController.text = widget.model.initialWeight.toString();
      _finalWeightController.text = widget.model.finalWeight.toString();
      _cleanlinessController.text = widget.model.cleanlinessScore.toString();
    } else if (widget.model.status == 2) {
      _attendanceStatus = AttendanceStatus.tugasLanjut;
    } else if (widget.model.status == 3) {
      _attendanceStatus = AttendanceStatus.tidakHadir;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _initialQtyController.dispose();
    _finalQtyController.dispose();
    _initialWeightController.dispose();
    _finalWeightController.dispose();
    _cleanlinessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Absensi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      readOnly: true,
                      initialValue: widget.model.employeeName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.blue,
                        label: Text('Nama Karyawan'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.blue,
                        label: Text('Tanggal Absensi'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 16.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            labelText: 'Jenis Pekerjaan',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.factory)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: radioValue,
                            hint: const Text(''),
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Cabut Sarang'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Bentuk Sarang'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                radioValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 16.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            labelText: 'Status Absensi',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.factory)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AttendanceStatus>(
                            isExpanded: true,
                            value: _attendanceStatus,
                            hint: const Text(''),
                            items: const [
                              DropdownMenuItem(
                                value: AttendanceStatus.tugasBaru,
                                child: Text('Memulai tugas baru'),
                              ),
                              DropdownMenuItem(
                                value: AttendanceStatus.tugasLanjut,
                                child: Text('Melanjutkan tugas'),
                              ),
                              DropdownMenuItem(
                                value: AttendanceStatus.tidakHadir,
                                child: Text('Tidak hadir'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _attendanceStatus = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_attendanceStatus == AttendanceStatus.tugasBaru)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _initialQtyController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.numbers),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.blue,
                                    label: Text('Jumlah Awal'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some space between the fields
                              Expanded(
                                child: TextFormField(
                                  controller: _finalQtyController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.numbers),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.blue,
                                    label: Text('Jumlah Akhir'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _initialWeightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.scale),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.blue,
                                    label: Text('Berat Awal'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8), // Add some space between the fields
                              Expanded(
                                child: TextFormField(
                                  controller: _finalWeightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.scale),
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusColor: Colors.blue,
                                    label: Text('Berat Akhir'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cleanlinessController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.percent),
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.blue,
                              label: Text('Nilai Kebersihan'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 64,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  final attendanceViewModel =
                      Provider.of<AttendanceViewModel>(context, listen: false);
                  final date = _dateController.text;
                  final type = radioValue;
                  final initialQty = _initialQtyController.text.isEmpty
                      ? null
                      : int.parse(_initialQtyController.text);
                  final finalQty = _finalQtyController.text.isEmpty
                      ? null
                      : int.parse(_finalQtyController.text);
                  final initialWeight = _initialQtyController.text.isEmpty
                      ? null
                      : double.parse(_initialWeightController.text);
                  final finalWeight = _finalWeightController.text.isEmpty
                      ? null
                      : double.parse(_finalWeightController.text);
                  final cleanScore = _cleanlinessController.text.isEmpty
                      ? null
                      : int.parse(_cleanlinessController.text);

                  try {
                    attendanceViewModel
                        .storeTodayLaborerAttendance(
                            widget.model,
                            date,
                            _attendanceStatus.toString().split('.').last,
                            type!,
                            initialQty,
                            finalQty,
                            initialWeight,
                            finalWeight,
                            cleanScore)
                        .then((_) {
                      showToast('Absensi berhasil disimpan', 'success');
                      setState(() {
                        _isLoading = false;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    });
                  } catch (e) {
                    showToast('Terjadi error saat mengirim ', 'error');
                  }
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : const Text(
                      'Simpan Absensi',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
