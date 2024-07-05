import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/salary/widget/salary_labor_form.dart';
import 'package:nanyang_application/module/salary/widget/salary_worker_form.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminFormScreen extends StatefulWidget {
  const SalaryAdminFormScreen({super.key});

  @override
  State<SalaryAdminFormScreen> createState() => _SalaryAdminFormScreenState();
}

class _SalaryAdminFormScreenState extends State<SalaryAdminFormScreen> {
  late final EmployeeModel _employee;
  late final SalaryViewModel _salaryViewModel;

  @override
  void initState() {
    super.initState();
    _salaryViewModel = context.read<SalaryViewModel>();
    _employee = _salaryViewModel.employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Gaji',
        isBackButton: true,
        isCenter: true,
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: _employee.position.type == 1 ? const SalaryWorkerForm() : const SalaryLaborForm()
      ),
    );
  }
}