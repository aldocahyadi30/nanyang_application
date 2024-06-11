import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/position.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
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
  late final ConfigurationProvider _config;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _birthplaceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _attendanceIDController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int? _selectedPosition;
  String? _selectedGender;

  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _employeeViewModel = context.read<EmployeeViewModel>();
    _model = _employeeViewModel.selectedEmployee;
    _config = context.read<ConfigurationProvider>();
    isEdit = widget.type == 'edit';

    _nameController.text = _model.name;
    _addressController.text = _model.address ?? '';
    _birthplaceController.text = _model.birthPlace ?? '';
    _phoneController.text = _model.phoneNumber ?? '';
    _salaryController.text = _model.salary.toString();
    _attendanceIDController.text = _model.attendanceMachineID.toString();
    _selectedGender = _model.gender;
    _selectedPosition = _model.position.id != 0 ? _model.position.id : null;
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
    int age;

    if (_birthdayController.text.isNotEmpty) {
      age = DateTime.now().year - _model.birthDate!.year;
    } else {
      age = _model.age ?? 0;
    }
    _model.name = _nameController.text;
    _model.address = _addressController.text;
    _model.birthPlace = _birthplaceController.text;
    _model.phoneNumber = _phoneController.text;
    _model.salary = double.parse(_salaryController.text);
    _model.attendanceMachineID = int.parse(_attendanceIDController.text);
    _model.entryDate = parseFormattedDate(_entryDateController.text);
    _model.birthDate = parseFormattedDate(_birthdayController.text);
    _model.age = age;
    _model.gender = _selectedGender;
    _model.position = PositionModel(id: _selectedPosition!, name: '', type: 0);

    _employeeViewModel.store();
  }

  Future<void> edit() async {
    int age;

    if (_birthdayController.text.isNotEmpty) {
      age = DateTime.now().year - _model.birthDate!.year;
    } else {
      age = _model.age ?? 0;
    }

    EmployeeModel updatedModel = _model.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        birthPlace: _birthplaceController.text,
        phoneNumber: _phoneController.text,
        salary: double.parse(_salaryController.text),
        attendanceMachineID: int.parse(_attendanceIDController.text),
        entryDate: parseFormattedDate(_entryDateController.text),
        birthDate: parseFormattedDate(_birthdayController.text),
        age: age,
        gender: _selectedGender,
        position: PositionModel(id: _selectedPosition!, name: '', type: 0));

    _employeeViewModel.setEmployee(updatedModel);
    _employeeViewModel.update();
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
                        _selectedPosition = value;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: dynamicHeight(16, context)),
              FormPickerField(
                  title: 'Tanggal Masuk',
                  picker: NanyangDatePicker(
                    type: 'normal',
                    selectedDate: _model.entryDate,
                    controller: _entryDateController,
                  ),
                  controller: _entryDateController),
              SizedBox(height: dynamicHeight(16, context)),
              FormTextField(
                title: 'Nomor Telepon',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: dynamicHeight(16, context)),
              if (widget.type == 'edit')
                Column(
                  children: [
                    FormTextField(
                      title: 'Alamat',
                      controller: _addressController,
                      isRequired: false,
                    ),
                    SizedBox(height: dynamicHeight(16, context)),
                    FormTextField(
                      title: 'Tempat Lahir',
                      controller: _birthplaceController,
                      isRequired: false,
                    ),
                    SizedBox(height: dynamicHeight(16, context)),
                    FormPickerField(
                        title: 'Tanggal Lahir',
                        isRequired: false,
                        picker: NanyangDatePicker(
                          type: 'normal',
                          selectedDate: _model.birthDate,
                          controller: _birthdayController,
                        ),
                        controller: _birthdayController),
                    SizedBox(height: dynamicHeight(16, context)),
                    FormDropdown(
                      title: 'Jenis Kelamin',
                      isRequired: false,
                      value: _selectedGender,
                      items: const [DropdownMenuItem(value: 'Pria', child: Text('Pria')), DropdownMenuItem(value: 'Wanita', child: Text('Wanita'))],
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value.toString();
                        });
                      },
                    ),
                    SizedBox(height: dynamicHeight(16, context)),
                  ],
                ),
              if (_config.user.level == 3)
                FormTextField(
                  title: 'Gaji',
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [inputCurrencyFormatter],
                ),
              SizedBox(height: dynamicHeight(16, context)),
              FormTextField(
                title: 'ID Mesin Absensi',
                controller: _attendanceIDController,
                keyboardType: TextInputType.number,
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
