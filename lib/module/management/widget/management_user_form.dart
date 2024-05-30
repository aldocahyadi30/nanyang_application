import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserForm extends StatefulWidget {
  final UserModel? model;

  const ManagementUserForm({super.key, this.model});

  @override
  State<ManagementUserForm> createState() => _ManagementUserFormState();
}

class _ManagementUserFormState extends State<ManagementUserForm> {
  late final AuthViewModel _authViewModel;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();

  // List<EmployeeModel> employee = [];
  int? selectedEmployee;
  int? selectedLevel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<AuthViewModel>();
    if (widget.model != null) {
      _emailController.text = widget.model!.email;
      selectedEmployee = widget.model!.employeeId;
      selectedLevel = widget.model!.level;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
  }

  void createEmployee(String email, String password, int employeeID, int level) async {
    await _authViewModel.register(email, password, employeeID, level);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void updateEmployee(String email, int employeeID, int level) async {
    await _authViewModel.update(widget.model!.id, email, employeeID, level);
    if (mounted) {
      Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.model != null;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Selector<EmployeeViewModel, List<EmployeeModel>>(
              selector: (context, viewmodel) => viewmodel.employee,
              builder: (context, employee, child) {
                return FormDropdown(
                  title: 'Karyawan',
                  items: employee.isEmpty
                      ? []
                      : employee.map((employee) {
                          return DropdownMenuItem<int>(
                            value: employee.id,
                            child: Text(employee.name),
                          );
                        }).toList(),
                  value: selectedEmployee,
                  onChanged: (value) {
                    setState(() {
                      selectedEmployee = value!;
                    });
                  },
                );
              },
            ),
            SizedBox(
              height: dynamicHeight(16, context),
            ),
            FormDropdown(
                title: 'Level',
                items: context.read<ConfigurationProvider>().user.level == 3
                    ? [
                        const DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Karyawan'),
                        ),
                        const DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Admin'),
                        ),
                        const DropdownMenuItem(
                          value: 3,
                          child: Text('Super Admin'),
                        ),
                      ]
                    : [
                        const DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Karyawan'),
                        ),
                        const DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Admin'),
                        ),
                      ],
                value: selectedLevel,
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                }),
            SizedBox(
              height: dynamicHeight(16, context),
            ),
            FormTextField(
              title: 'Email',
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tolong isi inputan ini';
                }
                if (!value.contains('@')) {
                  return 'Email tidak valid';
                }
                return null;
              },
            ),
            SizedBox(
              height: dynamicHeight(16, context),
            ),
            !isEdit
                ? Column(
                    children: [
                      FormTextField(
                        title: 'Password',
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tolong isi inputan ini';
                          }

                          if (value.length < 8) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: dynamicHeight(16, context),
                      ),
                      FormTextField(
                        title: 'Masukan Ulang Password',
                        controller: _retypePasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tolong isi inputan ini';
                          }

                          if (value.length < 8) {
                            return 'Password minimal 6 karakter';
                          }

                          if (value != _passwordController.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: dynamicHeight(32, context),
            ),
            FormButton(
              text: isEdit ? 'Simpan Perubahan' : 'Buat Akun',
              isLoading: isLoading,
              backgroundColor: ColorTemplate.lightVistaBlue,
              elevation: 8,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  if (isEdit) {
                    updateEmployee(_emailController.text, selectedEmployee!, selectedLevel!);
                  } else {
                    createEmployee(_emailController.text, _passwordController.text, selectedEmployee!, selectedLevel!);
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
    );
  }
}