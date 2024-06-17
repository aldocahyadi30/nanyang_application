import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/picker/nanyang_time_picker.dart';
import 'package:nanyang_application/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';

class AttendanceAdminForm extends StatefulWidget {
  const AttendanceAdminForm({super.key});

  @override
  State<AttendanceAdminForm> createState() => _AttendanceAdminFormState();
}

class _AttendanceAdminFormState extends State<AttendanceAdminForm> {
  final TextEditingController _initialQtyController = TextEditingController();
  final TextEditingController _finalQtyController = TextEditingController();
  final TextEditingController _initialWeightController = TextEditingController();
  final TextEditingController _finalWeightController = TextEditingController();
  final TextEditingController _depreciationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  int? _attendanceStatus;
  int? _featherType;
  bool _isLoading = false;
  bool _isLabor = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _initialQtyController.dispose();
    _finalQtyController.dispose();
    _initialWeightController.dispose();
    _finalWeightController.dispose();
    _depreciationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceViewModel>(
      builder: (context, viewmodel, child) {
        if (viewmodel.selectedAtt.employee.position.type == 2) {
          _isLabor = true;
        }
        if (_isLabor && viewmodel.selectedAtt.laborDetail!.id != 0) {
          _initialQtyController.text = viewmodel.selectedAtt.laborDetail!.initialQty.toString();
          _finalQtyController.text = viewmodel.selectedAtt.laborDetail!.finalQty.toString();
          _initialWeightController.text = viewmodel.selectedAtt.laborDetail!.initialWeight.toString();
          _finalWeightController.text = viewmodel.selectedAtt.laborDetail!.finalWeight.toString();
          _depreciationController.text = viewmodel.selectedAtt.laborDetail!.minDepreciation.toString();
          _attendanceStatus = viewmodel.selectedAtt.laborDetail!.status;
          _featherType = viewmodel.selectedAtt.laborDetail!.featherType;
        }
        return Form(
          key: _formKey,
          child: Column(
            children: [
              FormTextField(
                title: 'Nama Karyawan',
                initialValue: viewmodel.selectedAtt.employee.name,
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              FormTextField(
                title: 'Tanggal Absensi',
                initialValue: DateFormat('dd/MM/yyyy').format(viewmodel.selectedAdminDate),
                isReadOnly: true,
              ),
              SizedBox(height: dynamicHeight(24, context)),
              !_isLabor
                  ? Column(
                      children: [
                        FormPickerField(
                            title: 'Waktu Masuk',
                            picker: NanyangTimePicker(
                              selectedTime: viewmodel.selectedAtt.attendance!.checkIn != null
                                  ? TimeOfDay(hour: viewmodel.selectedAtt.attendance!.checkIn!.hour, minute: viewmodel.selectedAtt.attendance!.checkIn!.minute)
                                  : null,
                              onTimePicked: (time){
                                _startTimeController.text = time.format(context);
                              },
                            ),
                            controller: _startTimeController),
                        SizedBox(height: dynamicHeight(24, context)),
                        FormPickerField(
                            title: 'Waktu Pulang',
                            picker: NanyangTimePicker(
                              selectedTime: viewmodel.selectedAtt.attendance!.checkOut != null
                                  ? TimeOfDay(
                                      hour: viewmodel.selectedAtt.attendance!.checkOut!.hour, minute: viewmodel.selectedAtt.attendance!.checkOut!.minute)
                                  : null,
                              onTimePicked: (time){
                                _endTimeController.text = time.format(context);
                              },
                            ),
                            controller: _endTimeController),
                      ],
                    )
                  : Column(
                      children: [
                        FormDropdown<int>(
                          title: 'Status Absensi',
                          value: _attendanceStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Memulai tugas baru'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('Melanjutkan tugas'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _attendanceStatus = value;
                            });
                          },
                        ),
                        SizedBox(height: dynamicHeight(24, context)),
                        if (_attendanceStatus == 1)
                          Column(
                            children: [
                              FormDropdown<int>(
                                title: 'Jenis Bulu',
                                value: _featherType,
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Bulu Kecil'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Bulu Besar'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _featherType = value;
                                    if (value == 1) {
                                      _depreciationController.text = '11';
                                    } else {
                                      _depreciationController.text = '18';
                                    }
                                  });
                                },
                              ),
                              SizedBox(height: dynamicHeight(24, context)),
                              FormTextField(
                                title: 'Minimal Susut(%)',
                                keyboardType: TextInputType.number,
                                inputFormatters: [inputDoubleFormatter],
                                controller: _depreciationController,
                                // isReadOnly: ,
                              ),
                              SizedBox(height: dynamicHeight(24, context)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: FormTextField(
                                      title: 'Jumlah Awal',
                                      controller: _initialQtyController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: dynamicWidth(16, context)),
                                  Expanded(
                                    child: FormTextField(
                                      title: 'Jumlah Akhir',
                                      controller: _finalQtyController,
                                      keyboardType: TextInputType.number,
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
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [inputDoubleFormatter],
                                    ),
                                  ),
                                  SizedBox(width: dynamicWidth(16, context)),
                                  Expanded(
                                    child: FormTextField(
                                      title: 'Berat Akhir',
                                      controller: _finalWeightController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [inputDoubleFormatter],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

                    if (_isLabor) {
                      final initialQty = _initialQtyController.text.isEmpty ? 0 : int.parse(_initialQtyController.text);
                      final finalQty = _finalQtyController.text.isEmpty ? 0 : int.parse(_finalQtyController.text);
                      final initialWeight = _initialWeightController.text.isEmpty ? 0.0 : double.parse(_initialWeightController.text);
                      final finalWeight = _finalWeightController.text.isEmpty ? 0.0 : double.parse(_finalWeightController.text);
                      final minDeprecation = _depreciationController.text.isEmpty ? 0 : int.parse(_depreciationController.text);
                      viewmodel.storeLabor(_attendanceStatus!, _featherType!, initialQty, finalQty, initialWeight, finalWeight, minDeprecation).then((_) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    } else {
                      final starTime = _startTimeController.text.isEmpty ? '07:00' : _startTimeController.text;
                      final endTime = _endTimeController.text.isEmpty ? '16:30' : _endTimeController.text;

                      viewmodel.storeWorker(starTime, endTime).then((_) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
