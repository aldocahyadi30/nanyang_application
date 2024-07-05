import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/attendance.dart';
import 'package:nanyang_application/model/attendance_admin.dart';
import 'package:nanyang_application/model/attendance_detail.dart';
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
  late final AttendanceViewModel _viewmodel;
  late final AttendanceAdminModel _model;
  final TextEditingController _initialQtyController = TextEditingController();
  final TextEditingController _finalQtyController = TextEditingController();
  final TextEditingController _initialWeightController = TextEditingController();
  final TextEditingController _finalWeightController = TextEditingController();
  final TextEditingController _depreciationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  bool _isLoading = false;
  bool _isLabor = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewmodel = context.read<AttendanceViewModel>();
    if (_viewmodel.selectedAtt.employee.position.type == 2) {
      _isLabor = true;
    }

    if (_isLabor) {
      if (_viewmodel.selectedAtt.laborDetail!.id != 0) {
        _model = AttendanceAdminModel.copyWith(
            employee: _viewmodel.selectedAtt.employee, attendance: _viewmodel.selectedAtt.attendance, laborDetail: _viewmodel.selectedAtt.laborDetail!);
      } else {
        _model = AttendanceAdminModel(
          employee: _viewmodel.selectedAtt.employee,
          attendance: AttendanceModel.empty(),
          laborDetail: AttendanceDetailModel.empty(),
        );
      }

      _initialQtyController.text = _model.laborDetail!.id != 0 ? _model.laborDetail!.initialQty.toString() : '';
      _finalQtyController.text = _model.laborDetail!.id != 0 ? _model.laborDetail!.finalQty.toString() : '';
      _initialWeightController.text = _model.laborDetail!.id != 0 ? _model.laborDetail!.initialWeight.toString() : '';
      _finalWeightController.text = _model.laborDetail!.id != 0 ? _model.laborDetail!.finalWeight.toString() : '';
      _depreciationController.text = _model.laborDetail!.id != 0 ? _model.laborDetail!.minDepreciation.toString() : '';
    } else {
      if (_viewmodel.selectedAtt.attendance != null && _viewmodel.selectedAtt.attendance!.id != 0) {
        _model = AttendanceAdminModel.copyWith(employee: _viewmodel.selectedAtt.employee, attendance: _viewmodel.selectedAtt.attendance);
      } else {
        _model = AttendanceAdminModel(
          employee: _viewmodel.selectedAtt.employee,
          attendance: AttendanceModel.empty(),
        );
      }

      _startTimeController.text = _model.attendance!.checkIn != null ? DateFormat('HH:mm').format(_model.attendance!.checkIn!) : '';
      _endTimeController.text = _model.attendance!.checkOut != null ? DateFormat('HH:mm').format(_model.attendance!.checkOut!) : '';
    }
  }

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormTextField(
            title: 'Nama Karyawan',
            initialValue: _model.employee.name,
            isReadOnly: true,
          ),
          SizedBox(height: dynamicHeight(24, context)),
          FormTextField(
            title: 'Tanggal Absensi',
            initialValue: DateFormat('dd/MM/yyyy').format(_viewmodel.selectedAdminDate),
            isReadOnly: true,
          ),
          SizedBox(height: dynamicHeight(24, context)),
          !_isLabor
              ? Column(
                  children: [
                    FormPickerField(
                        title: 'Waktu Masuk',
                        picker: NanyangTimePicker(
                          selectedTime: _model.attendance!.checkIn != null
                              ? TimeOfDay(hour: _model.attendance!.checkIn!.hour, minute: _model.attendance!.checkIn!.minute)
                              : null,
                          onTimePicked: (time) {
                            _startTimeController.text = time.format(context);
                            _model.attendance!.checkIn = DateTime(_viewmodel.selectedAdminDate.year, _viewmodel.selectedAdminDate.month,
                                _viewmodel.selectedAdminDate.day, time.hour, time.minute);
                          },
                        ),
                        controller: _startTimeController),
                    SizedBox(height: dynamicHeight(24, context)),
                    FormPickerField(
                        title: 'Waktu Pulang',
                        picker: NanyangTimePicker(
                          selectedTime: _model.attendance!.checkOut != null
                              ? TimeOfDay(hour: _model.attendance!.checkOut!.hour, minute: _model.attendance!.checkOut!.minute)
                              : null,
                          onTimePicked: (time) {
                            _endTimeController.text = time.format(context);
                            _model.attendance!.checkOut = DateTime(_viewmodel.selectedAdminDate.year, _viewmodel.selectedAdminDate.month,
                                _viewmodel.selectedAdminDate.day, time.hour, time.minute);
                          },
                        ),
                        controller: _endTimeController),
                  ],
                )
              : Column(
                  children: [
                    FormDropdown<int>(
                      title: 'Status Absensi',
                      value: _model.laborDetail!.status != 0 ? _model.laborDetail!.status : null,
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
                          _model.laborDetail!.status = value;
                        });
                      },
                    ),
                    SizedBox(height: dynamicHeight(24, context)),
                    if (_model.laborDetail!.status == 1)
                      Column(
                        children: [
                          FormDropdown<int>(
                            title: 'Jenis Bulu',
                            value: _model.laborDetail != null ? _model.laborDetail!.featherType : 1,
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
                                _model.laborDetail!.featherType = value;
                                if (value == 1) {
                                  _depreciationController.text = '11';
                                  _model.laborDetail!.minDepreciation = 11;
                                } else {
                                  _depreciationController.text = '18';
                                  _model.laborDetail!.minDepreciation = 18;
                                }
                              });
                            },
                          ),
                          SizedBox(height: dynamicHeight(24, context)),
                          FormTextField(
                            title: 'Minimal Susut(%)',
                            keyboardType: TextInputType.number,
                            controller: _depreciationController,
                            onChanged: (value) {
                              setState(() {
                                _model.laborDetail!.minDepreciation = int.parse(value!);
                              });
                            },
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
                                  onChanged: (value) {
                                    setState(() {
                                      _model.laborDetail!.initialQty = int.parse(value!);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: dynamicWidth(16, context)),
                              Expanded(
                                child: FormTextField(
                                  title: 'Jumlah Akhir',
                                  controller: _finalQtyController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _model.laborDetail!.finalQty = int.parse(value!);
                                    });
                                  },
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
                                  onChanged: (value) {
                                    setState(() {
                                      _model.laborDetail!.initialWeight = double.parse(value!);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: dynamicWidth(16, context)),
                              Expanded(
                                child: FormTextField(
                                  title: 'Berat Akhir',
                                  controller: _finalWeightController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _model.laborDetail!.finalWeight = double.parse(value!);
                                    });
                                  },
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
                  
                  _viewmodel.storeLabor(_model).then((_) {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context);
                  });
                } else {
                  _viewmodel.storeWorker(_model).then((_) {
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
  }
}