import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/salary.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminFormScreen extends StatefulWidget {
  const SalaryAdminFormScreen({super.key});

  @override
  State<SalaryAdminFormScreen> createState() => _SalaryAdminFormScreenState();
}

class _SalaryAdminFormScreenState extends State<SalaryAdminFormScreen> {
  late final SalaryModel _salary;
  late final EmployeeModel _employee;
  late final SalaryViewModel _salaryViewModel;
  final _formKey = GlobalKey<FormState>();
  late final bool isEdit;
  late final String _period;
  late final double _monthlySalary;
  final TextEditingController _attendanceQtyController = TextEditingController();
  final TextEditingController _workingDayController = TextEditingController();
  final TextEditingController _overtimeController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _deductionController = TextEditingController();
  final TextEditingController _dailySalaryController = TextEditingController();
  final TextEditingController _bpjsRateController = TextEditingController();
  final TextEditingController _bpjsController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _salaryViewModel = context.read<SalaryViewModel>();
    _salary = _salaryViewModel.salary;
    _employee = _salaryViewModel.employee;
    isEdit = _salary.id != 0;
    if (isEdit) {
      _period = _salary.period;
      _monthlySalary = _salary.monthlySalary;
      _attendanceQtyController.text = _salary.totalAttendance.toString();
      _workingDayController.text = _salary.totalWorkingDay.toString();
      _overtimeController.text = formatCurrency(_salary.totalOvertime);
      _bonusController.text = formatCurrency(_salary.totalBonus);
      _deductionController.text = formatCurrency(_salary.totalDeduction);
      if (_salary.totalWorkingDay > 0) {
        _dailySalaryController.text = formatCurrency(_salary.monthlySalary / _salary.totalWorkingDay);
      } else {
        _dailySalaryController.text = formatCurrency(0);
      }
      _bpjsRateController.text = _salary.bpjsRate.toString();
      if (_salary.bpjsRate > 0) {
        _bpjsController.text = formatCurrency(_monthlySalary * (_salary.bpjsRate / 100));
      } else {
        _bpjsController.text = formatCurrency(0);
      }
      _noteController.text = _salary.note;
    } else {
      _period = DateFormat('yyyyMM').format(DateTime.now());
      _monthlySalary = _employee.salary!;
      _attendanceQtyController.text = _salary.totalAttendance.toString();
      _workingDayController.text = _salary.totalWorkingDay.toString();
      _overtimeController.text = formatCurrency(_salary.totalOvertime);
      _bonusController.text = formatCurrency(_salary.totalBonus);
      _deductionController.text = formatCurrency(_salary.totalDeduction);
      if (_salary.totalWorkingDay > 0) {
        _dailySalaryController.text = formatCurrency(_salary.monthlySalary / _salary.totalWorkingDay);
      } else {
        _dailySalaryController.text = formatCurrency(0);
      }
      _bpjsRateController.text = _salary.bpjsRate != 0 ? _salary.bpjsRate.toString() : '0';
      if (_salary.bpjsRate > 0) {
        _bpjsController.text = formatCurrency(_monthlySalary * (_salary.bpjsRate / 100));
      } else {
        _bpjsController.text = formatCurrency(0);
      }
      _noteController.text = _salary.note;
    }
  }

  Future<void> store() async {
    _salary.period = _period;
    _salary.monthlySalary = _monthlySalary;
    _salary.totalAttendance = int.tryParse(_attendanceQtyController.text) ?? 0;
    _salary.totalWorkingDay = int.tryParse(_workingDayController.text) ?? 0;
    _salary.totalOvertime = double.tryParse(_overtimeController.text) ?? 0;
    _salary.totalBonus = double.tryParse(_bonusController.text) ?? 0;
    _salary.totalDeduction = double.tryParse(_deductionController.text) ?? 0;
    _salary.bpjsRate = double.tryParse(_bpjsRateController.text) ?? 0;
    double dailySalary = _monthlySalary / _salary.totalWorkingDay;
    _salary.totalSalary = (dailySalary * _salary.totalAttendance) +
        _salary.totalOvertime +
        _salary.totalBonus -
        _salary.totalDeduction -
        (_monthlySalary * (_salary.bpjsRate / 100));
    _salary.note = _noteController.text;

    await _salaryViewModel.store();
  }

  Future<void> update() async {
    SalaryModel newSalary = SalaryModel.copyWith(
      _salary,
      totalAttendance: int.tryParse(_attendanceQtyController.text),
      totalWorkingDay: int.tryParse(_workingDayController.text),
      totalOvertime: double.tryParse(_overtimeController.text),
      totalBonus: double.tryParse(_bonusController.text),
      totalDeduction: double.tryParse(_deductionController.text),
      bpjsRate: double.tryParse(_bpjsRateController.text),
      totalSalary: ((_salary.monthlySalary / _salary.totalWorkingDay) * _salary.totalAttendance) +
          _salary.totalOvertime +
          _salary.totalBonus -
          _salary.totalDeduction -
          (_monthlySalary * (_salary.bpjsRate / 100)),
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    _salaryViewModel.setSalary(newSalary);
    await _salaryViewModel.update();
  }

  @override
  void dispose() {
    super.dispose();
    _attendanceQtyController.dispose();
    _workingDayController.dispose();
    _overtimeController.dispose();
    _bonusController.dispose();
    _deductionController.dispose();
    _dailySalaryController.dispose();
    _bpjsRateController.dispose();
    _bpjsController.dispose();
    _noteController.dispose();
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormTextField(
                  title: 'Nama',
                  initialValue: _employee.name,
                  isReadOnly: true,
                  isRequired: false,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Period',
                  initialValue: _period,
                  isReadOnly: true,
                  isRequired: false,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Gaji Pokok',
                  initialValue: formatCurrency(_monthlySalary),
                  isReadOnly: true,
                  isRequired: false,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FormTextField(
                        title: 'Hari Kerja',
                        controller: _workingDayController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          final workingDay = int.tryParse(value ?? '0') ?? 0;
                          if (workingDay > 0) {
                            final dailySalary = _monthlySalary / workingDay;
                            _dailySalaryController.text = formatCurrency(dailySalary);
                          } else {
                            _dailySalaryController.text = formatCurrency(0);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: dynamicWidth(8, context)),
                    Expanded(
                      flex: 2,
                      child: FormTextField(
                        title: 'Gaji/Hari',
                        controller: _dailySalaryController,
                        inputFormatters: [formatInputCurrencty()],
                        isReadOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: dynamicHeight(16, context)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FormTextField(
                        title: 'BPJS (%)',
                        controller: _bpjsRateController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final bpjsRate = double.tryParse(value ?? '0') ?? 0;

                          if (bpjsRate > 0) {
                            final bpjs = _monthlySalary * (bpjsRate / 100);
                            _bpjsController.text = formatCurrency(bpjs);
                          } else {
                            _bpjsController.text = formatCurrency(0);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: dynamicWidth(8, context)),
                    Expanded(
                      flex: 2,
                      child: FormTextField(
                        title: 'Nominal BPJS',
                        controller: _bpjsController,
                        inputFormatters: [formatInputCurrencty()],
                        isReadOnly: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Lembur',
                  controller: _overtimeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [formatInputCurrencty()],
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Tunjangan',
                  controller: _bonusController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [formatInputCurrencty()],
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Potongan',
                  controller: _deductionController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [formatInputCurrencty()],
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Keterangan',
                  isRequired: false,
                  controller: _noteController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: dynamicHeight(28, context)),
                FormButton(
                    text: 'Simpan',
                    isLoading: _isLoading,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });

                      if (isEdit) {
                      } else {}

                      setState(() {
                        _isLoading = false;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
