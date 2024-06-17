import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/position.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementEmployeeFormScreen extends StatefulWidget {
  final String type;
  const ManagementEmployeeFormScreen({super.key, required this.type});

  @override
  State<ManagementEmployeeFormScreen> createState() => _ManagementEmployeeFormScreenState();
}

class _ManagementEmployeeFormScreenState extends State<ManagementEmployeeFormScreen> {
  late final EmployeeViewModel _employeeViewModel;
  late final EmployeeModel _model;
  late final UserModel _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _birthplaceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _attendanceIDController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _employeeViewModel = context.read<EmployeeViewModel>();
    _user = context.read<ConfigurationViewModel>().user;
    isEdit = widget.type == 'edit';

    if (isEdit) {
      _model = _employeeViewModel.selectedEmployee;
    } else {
      _model = EmployeeModel.copyWith(_employeeViewModel.selectedEmployee);
    }

    _nameController.text = _model.name;
    _addressController.text = _model.address ?? '';
    _birthplaceController.text = _model.birthPlace ?? '';
    _phoneController.text = _model.phoneNumber ?? '';
    _salaryController.text = _model.salary.toString();
    _attendanceIDController.text = _model.attendanceMachineID.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _entryDateController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    _attendanceIDController.dispose();
    _birthdayController.dispose();
    _birthplaceController.dispose();
    _addressController.dispose();
  }

  Future<void> store() async {
    await _employeeViewModel.store(_model);
  }

  Future<void> edit() async {
    await _employeeViewModel.update(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Karyawan',
        isCenter: true,
        isBackButton: true,
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(8, 16, context),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              FormTextField(
                title: 'Nama',
                controller: _nameController,
                onChanged: (value) {
                  if (value!.isNotEmpty){
                    _model.name = value;
                  }
                },
              ),
              SizedBox(height: dynamicHeight(16, context)),
              Selector<ConfigurationViewModel, List<PositionModel>>(
                selector: (context, viewmodel) => viewmodel.position,
                builder: (context, position, child) {
                  return FormDropdown<int>(
                    title: 'Posisi',
                    value: isEdit ? _model.position.id : null,
                    items: position.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _model.position = position.firstWhere((element) => element.id == value);
                      });
                    },
                  );
                },
              ),
              SizedBox(height: dynamicHeight(16, context)),
              FormPickerField(
                  title: 'Tanggal Masuk',
                  picker: NanyangDatePicker(
                    selectedDate: _model.entryDate,
                    controller: _entryDateController,
                    onDatePicked: (date) {
                      _entryDateController.text = parseDateToStringFormatted(date);
                      _model.entryDate = date;
                    },
                  ),
                  controller: _entryDateController),
              SizedBox(height: dynamicHeight(16, context)),
              FormTextField(
                title: 'Nomor Telepon',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (value!.isNotEmpty){
                    _model.phoneNumber = value;
                  }
                },
              ),
              SizedBox(height: dynamicHeight(16, context)),
              if (widget.type == 'edit')
                Column(
                  children: [
                    FormTextField(
                      title: 'Alamat',
                      controller: _addressController,
                      isRequired: false,
                      onChanged: (value){
                        if (value!.isNotEmpty){
                          _model.address = value;
                        }
                      },
                    ),
                    SizedBox(height: dynamicHeight(16, context)),
                    FormTextField(
                      title: 'Tempat Lahir',
                      controller: _birthplaceController,
                      isRequired: false,
                      onChanged: (value){
                        if (value!.isNotEmpty){
                          _model.birthPlace = value;
                        }
                      },
                    ),
                    SizedBox(height: dynamicHeight(16, context)),
                    FormPickerField(
                        title: 'Tanggal Lahir',
                        isRequired: false,
                        picker: NanyangDatePicker(
                          selectedDate: _model.birthDate,
                          controller: _birthdayController,
                          onDatePicked: (date){
                            _birthdayController.text = parseDateToStringFormatted(date);
                            _model.birthDate = date;
                            _model.age = DateTime.now().year - date.year;
                          },
                        ),
                        controller: _birthdayController),
                    SizedBox(height: dynamicHeight(16, context)),
                    FormDropdown(
                      title: 'Jenis Kelamin',
                      isRequired: false,
                      value: _model.gender,
                      items: const [DropdownMenuItem(value: 'Pria', child: Text('Pria')), DropdownMenuItem(value: 'Wanita', child: Text('Wanita'))],
                      onChanged: (value) {
                        setState(() {
                          _model.gender = value.toString();
                        });
                      },
                    ),
                    SizedBox(height: dynamicHeight(16, context)),
                  ],
                ),
              if (_user.level == 3)
                FormTextField(
                  title: 'Gaji',
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [inputCurrencyFormatter],
                  onChanged: (value){
                    if (value!.isNotEmpty){
                      _model.salary = double.parse(value);
                    }
                  },
                ),
              SizedBox(height: dynamicHeight(16, context)),
              FormTextField(
                title: 'ID Mesin Absensi',
                controller: _attendanceIDController,
                keyboardType: TextInputType.number,
                onChanged: (value){
                  if (value!.isNotEmpty){
                    _model.attendanceMachineID = int.parse(value);
                  }
                },
              ),
              SizedBox(height: dynamicHeight(32, context)),
              FormButton(
                text: isEdit ? 'Simpan Perubahan' : 'Buat Karyawan',
                isLoading: isLoading,
                backgroundColor: ColorTemplate.lightVistaBlue,
                elevation: 8,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    if (isEdit) {
                      await edit();
                    } else {
                      await store();
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
              SizedBox(height: dynamicHeight(16, context)),
            ],
          )),
        ),
      ),
    );
  }
}
