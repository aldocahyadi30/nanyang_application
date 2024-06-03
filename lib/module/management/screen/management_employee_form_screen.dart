import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

enum gender { pria, wanita }

class ManagementEmployeeFormScreen extends StatefulWidget {
  const ManagementEmployeeFormScreen({super.key});

  @override
  State<ManagementEmployeeFormScreen> createState() => _ManagementEmployeeFormScreenState();
}

class _ManagementEmployeeFormScreenState extends State<ManagementEmployeeFormScreen> {
  late final EmployeeViewModel _employeeViewModel;
  late final ConfigurationProvider _config;
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _birthdayController = TextEditingController();
  // final TextEditingController _birthplaceController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _bpjsController = TextEditingController();
  final TextEditingController _attendanceIDController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _employeeViewModel = context.read<EmployeeViewModel>();
    _config = context.read<ConfigurationProvider>();

  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _entryDateController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    _bpjsController.dispose();
    _attendanceIDController.dispose();
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
                FormPickerField(title: 'Tanggal Masuk', picker: NanyangDatePicker(type: 'normal', controller: _entryDateController,), controller: _entryDateController),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Nomor Telepon',
                  controller: _phoneController,
                  type: TextInputType.phone,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Gaji',
                  controller: _salaryController,
                  type: TextInputType.number,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Nomor BPJS',
                  controller: _bpjsController,
                  type: const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'ID Mesin Absensi',
                  controller: _attendanceIDController,
                  type: TextInputType.number,
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
                      } else {
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
