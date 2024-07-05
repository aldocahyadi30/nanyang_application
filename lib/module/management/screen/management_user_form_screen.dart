import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserFormScreen extends StatefulWidget {
  const ManagementUserFormScreen({super.key});

  @override
  State<ManagementUserFormScreen> createState() => _ManagementUserFormScreenState();
}

class _ManagementUserFormScreenState extends State<ManagementUserFormScreen> {
  late final AuthViewModel _authViewModel;
  late final UserModel _model;
  late final UserModel _user;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  bool isLoading = false;
  bool isEdit = false;
  bool isObscure1 = true;
  bool isObscure2 = true;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthViewModel>().user;
    _authViewModel = context.read<AuthViewModel>();
    if (context.read<UserViewModel>().selectedUser.id == '') {
      _model = context.read<UserViewModel>().selectedUser;
    } else {
      _model = UserModel.copyWith(context.read<UserViewModel>().selectedUser);
      isEdit = true;
      _emailController.text = _model.email;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'User',
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
                      value: _model.employee.id != 0 ? _model.employee.id : null,
                      onChanged: (value) {
                        setState(() {
                          _model.employee =
                              EmployeeModel.copyWith(employee.firstWhere((element) => element.id == value));
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
                    items: _user.level == 3
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
                    value: _model.id != '' ? _model.level : null,
                    onChanged: (value) {
                      setState(() {
                        _model.level = value;
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
                  onChanged: (value) {
                    if (value!.isNotEmpty) _model.email = value;
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
                            isObscure: isObscure1,
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
                            isObscure: isObscure2,
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
                        _authViewModel.update(_model);
                      } else {
                        _authViewModel.register(_model, _passwordController.text);
                      }

                      Navigator.pop(context);
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