import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:provider/provider.dart';

class SalaryConfigurationScreen extends StatefulWidget {
  const SalaryConfigurationScreen({super.key});

  @override
  State<SalaryConfigurationScreen> createState() => _SalaryConfigurationScreenState();
}

class _SalaryConfigurationScreenState extends State<SalaryConfigurationScreen> {
  final TextEditingController _foodAllowanceWorkerController = TextEditingController();
  final TextEditingController _foodAllowanceLaborontroller = TextEditingController();
  int _selectedDay = 1;
  bool isEdit = false;
  bool isLoading = false;

  final List<int> _listDay = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: NanyangAppbar(
        title: 'Gaji',
        isBackButton: true,
        isCenter: true,
        actions: [
          !isEdit
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  icon: const Icon(Icons.edit, color: ColorTemplate.vistaBlue),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  icon: const Icon(Icons.close, color: ColorTemplate.vistaBlue),
                ),
        ],
      ),
      body: Consumer<ConfigurationProvider>(builder: (context, provider, child) {
        _foodAllowanceWorkerController.text = provider.configuration.foodAllowanceWorker.toString();
        _foodAllowanceLaborontroller.text = provider.configuration.foodAllowanceLabor.toString();
        _selectedDay = provider.configuration.cutoffDay;
        return Container(
          padding: dynamicPaddingSymmetric(8, 16, context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormTextField(
                  title: 'Uang Makan Karyawan',
                  keyboardType: TextInputType.number,
                  inputFormatters: [inputCurrencyFormatter],
                  controller: _foodAllowanceWorkerController,
                  isReadOnly: !isEdit,
                ),
                SizedBox(
                  height: dynamicHeight(16, context),
                ),
                FormTextField(
                  title: 'Uang Makan Cabutan',
                  keyboardType: TextInputType.number,
                  inputFormatters: [inputCurrencyFormatter],
                  controller: _foodAllowanceWorkerController,
                  isReadOnly: !isEdit,
                ),
                SizedBox(
                  height: dynamicHeight(16, context),
                ),
                FormDropdown(
                  isReadOnly: !isEdit,
                  title: 'Hari Cutoff',
                  items: _listDay.map(
                    (day) {
                      return DropdownMenuItem<int>(
                        value: day,
                        child: Text(day.toString()),
                      );
                    },
                  ).toList(),
                  value: _selectedDay,
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value as int;
                    });
                  },
                ),
                SizedBox(
                  height: dynamicHeight(28, context),
                ),
                isEdit
                    ? FormButton(
                        text: 'Simpan',
                        isLoading: isLoading,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          setState(() {
                            isLoading = true;
                          });
                        })
                    : Container(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
