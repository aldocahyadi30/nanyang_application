import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/salary.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryLaborForm extends StatefulWidget {
  const SalaryLaborForm({super.key});

  @override
  State<SalaryLaborForm> createState() => _SalaryLaborFormState();
}

class _SalaryLaborFormState extends State<SalaryLaborForm> {
  late final SalaryModel _salary;
  late final EmployeeModel _employee;
  late final SalaryViewModel _salaryViewModel;
  final _formKey = GlobalKey<FormState>();
  late final bool isEdit;
  late final String _period;
  double _gramSalary = 0;
  final TextEditingController _overtimeController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _deductionController = TextEditingController();
  final TextEditingController _bpjsRateController = TextEditingController();
  final TextEditingController _bpjsController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _gramController = TextEditingController();
  final TextEditingController _gramSalaryController = TextEditingController();
  final TextEditingController _totalSalaryController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _salaryViewModel = context.read<SalaryViewModel>();
    _employee = _salaryViewModel.employee;
    isEdit = _salaryViewModel.salary.id != 0;
    if (isEdit) {
      _salary = SalaryModel.copyWith(_salaryViewModel.salary);
      _period = _salary.period;
    } else {
      _salary = _salaryViewModel.salary;
      _period = DateFormat('yyyyMM').format(_salaryViewModel.selectedDate);
      _salary.period = _period;
      _salary.baseSalary = context.read<ConfigurationViewModel>().currentConfig.laborBaseSalary;
    }
    if (_salary.totalGram > 0) {
      _gramController.text = _salary.totalGram.toString();
      _gramSalary = (_salary.totalGram / 10) * _salary.baseSalary;
    } else {
      _gramController.text = '0';
      _gramSalary = 0;
    }
    _gramSalaryController.text = formatCurrency(_gramSalary);

    _overtimeController.text = formatCurrency(_salary.totalOvertime);
    _bonusController.text = formatCurrency(_salary.totalBonus);
    _deductionController.text = formatCurrency(_salary.totalDeduction);
    _bpjsRateController.text = _salary.bpjsRate != 0 ? _salary.bpjsRate.toString() : '0';
    if (_salary.bpjsRate > 0) {
      _bpjsController.text = formatCurrency((_gramSalary) * (_salary.bpjsRate / 100));
    } else {
      _bpjsController.text = formatCurrency(0);
    }
    _noteController.text = _salary.note;
    _totalSalaryController.text = formatCurrency(countTotalSalary());
  }

  Future<void> store() async {
    await _salaryViewModel.store(_salary);
  }

  Future<void> update() async {
    await _salaryViewModel.update(_salary);
  }

  double countTotalSalary() {
    _salary.totalSalary =
        _gramSalary + _salary.totalBonus + _salary.totalOvertime - _salary.totalDeduction - (_gramSalary * (_salary.bpjsRate / 100));

    return _salary.totalSalary;
  }

  @override
  void dispose() {
    super.dispose();
    _overtimeController.dispose();
    _bonusController.dispose();
    _deductionController.dispose();
    _bpjsRateController.dispose();
    _bpjsController.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              title: 'Gaji / 10 Gram',
              initialValue: formatCurrency(context.read<ConfigurationViewModel>().currentConfig.laborBaseSalary),
              isReadOnly: true,
              isRequired: false,
            ),
            SizedBox(height: dynamicHeight(16, context)),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: FormTextField(
                    title: 'Total Gram',
                    controller: _gramController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final gram = double.tryParse(value ?? '0') ?? 0;
                      _salary.totalGram = gram;

                      if (gram > 0) {
                        final gramSalary = (gram / 10) * _salary.baseSalary;
                        _gramSalaryController.text = formatCurrency(gramSalary);
                        _gramSalary = gramSalary;
                      } else {
                        _gramSalaryController.text = formatCurrency(0);
                        _gramSalary = 0;
                      }

                      _totalSalaryController.text = formatCurrency(countTotalSalary());
                    },
                  ),
                ),
                SizedBox(width: dynamicWidth(8, context)),
                Expanded(
                  flex: 2,
                  child: FormTextField(
                    title: 'Total Gaji/ 10 Gram',
                    controller: _gramSalaryController,
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
                      _salary.bpjsRate = bpjsRate;

                      if (bpjsRate > 0) {
                        final bpjs = _gramSalary * (bpjsRate / 100);
                        _bpjsController.text = formatCurrency(bpjs);
                      } else {
                        _bpjsController.text = formatCurrency(0);
                      }

                      _totalSalaryController.text = formatCurrency(countTotalSalary());
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
              onChanged: (value) {
                if (value!.isNotEmpty) {
                  _salary.totalOvertime = removeCurrencyFormat(value);
                  _totalSalaryController.text = formatCurrency(countTotalSalary());
                }
              },
            ),
            SizedBox(height: dynamicHeight(16, context)),
            FormTextField(
              title: 'Tunjangan',
              controller: _bonusController,
              keyboardType: TextInputType.number,
              inputFormatters: [formatInputCurrencty()],
              onChanged: (value) {
                if (value!.isNotEmpty) {
                  _salary.totalBonus = removeCurrencyFormat(value);
                  _totalSalaryController.text = formatCurrency(countTotalSalary());
                }
              },
            ),
            SizedBox(height: dynamicHeight(16, context)),
            FormTextField(
              title: 'Potongan',
              controller: _deductionController,
              keyboardType: TextInputType.number,
              inputFormatters: [formatInputCurrencty()],
              onChanged: (value) {
                if (value!.isNotEmpty) {
                  _salary.totalDeduction = removeCurrencyFormat(value);
                  _totalSalaryController.text = formatCurrency(countTotalSalary());
                }
              },
            ),
            SizedBox(height: dynamicHeight(16, context)),
            FormTextField(
              title: 'Total Gaji',
              controller: _totalSalaryController,
              inputFormatters: [formatInputCurrencty()],
              isReadOnly: true,
            ),
            SizedBox(height: dynamicHeight(16, context)),
            FormTextField(
              title: 'Keterangan',
              isRequired: false,
              controller: _noteController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                if (value!.isNotEmpty) _salary.note = value;
              },
            ),
            SizedBox(height: dynamicHeight(28, context)),
            FormButton(
              text: 'Simpan',
              isLoading: _isLoading,
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });

                if (isEdit) {
                  await update();
                } else {
                  await store();
                }

                setState(() {
                  _isLoading = false;
                });
              },
            ),
            SizedBox(height: dynamicHeight(16, context)),
          ],
        ),
      ),
    );
  }
}