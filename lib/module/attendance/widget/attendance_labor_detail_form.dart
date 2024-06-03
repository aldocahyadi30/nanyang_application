import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/attendance_labor.dart';
import 'package:nanyang_application/module/attendance/screen/attendance_admin_screen.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
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
  final TextEditingController _initialWeightController = TextEditingController();
  final TextEditingController _finalWeightController = TextEditingController();
  final TextEditingController _cleanlinessController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = Provider.of<DateProvider>(context, listen: false).attendanceLaborDateStringFormat;
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
      child: Padding(
        padding: dynamicPaddingAll(16, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormTextField(
              title: 'Nama Karyawan',
              initialValue: widget.model.employeeName,
              isReadOnly: true,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            FormTextField(
              title: 'Tanggal Absensi',
              controller: _dateController,
              isReadOnly: true,
            ),
            SizedBox(height: dynamicHeight(24, context)),
            FormDropdown<int>(
              title: 'Jenis Pekerjaan',
              value: radioValue,
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
            SizedBox(height: dynamicHeight(24, context)),
            FormDropdown<AttendanceStatus>(
              title: 'Status Absensi',
              value: _attendanceStatus,
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
            SizedBox(height: dynamicHeight(24, context)),
            if (_attendanceStatus == AttendanceStatus.tugasBaru)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FormTextField(
                          title: 'Jumlah Awal',
                          controller: _initialQtyController,
                          type: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: dynamicWidth(16, context)),
                      Expanded(
                        child: FormTextField(
                          title: 'Jumlah Akhir',
                          controller: _finalQtyController,
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dynamicHeight(24, context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FormTextField(
                          title: 'Berat Awal',
                          controller: _initialWeightController,
                          type: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: dynamicWidth(16, context)),
                      Expanded(
                        child: FormTextField(
                          title: 'Berat Akhir',
                          controller: _finalWeightController,
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dynamicHeight(24, context)),
                  FormTextField(title: 'Nilai Kebersihan', controller: _cleanlinessController, type: TextInputType.number),
                ],
              ),
            SizedBox(height: dynamicHeight(32, context)),
            FormButton(
              text: 'Simpan Absensi',
              isLoading: _isLoading,
              backgroundColor: ColorTemplate.lightVistaBlue,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  final attendanceViewModel = Provider.of<AttendanceViewModel>(context, listen: false);
                  final date = _dateController.text;
                  final type = radioValue;
                  final initialQty = _initialQtyController.text.isEmpty ? null : int.parse(_initialQtyController.text);
                  final finalQty = _finalQtyController.text.isEmpty ? null : int.parse(_finalQtyController.text);
                  final initialWeight = _initialQtyController.text.isEmpty ? null : double.parse(_initialWeightController.text);
                  final finalWeight = _finalWeightController.text.isEmpty ? null : double.parse(_finalWeightController.text);
                  final cleanScore = _cleanlinessController.text.isEmpty ? null : int.parse(_cleanlinessController.text);

                  attendanceViewModel
                      .storeTodayLaborerAttendance(
                          widget.model, date, _attendanceStatus.toString().split('.').last, type!, initialQty, finalQty, initialWeight, finalWeight, cleanScore)
                      .then((_) {
                    setState(() {
                      _isLoading = false;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AttendanceAdminScreen()));
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
