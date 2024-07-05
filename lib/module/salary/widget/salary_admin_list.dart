import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/module/global/picker/nanyang_month_picker.dart';
import 'package:nanyang_application/module/salary/widget/salary_admin_card.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminList extends StatefulWidget {
  final int type;
  const SalaryAdminList({super.key, required this.type});

  @override
  State<SalaryAdminList> createState() => _SalaryAdminListState();
}

class _SalaryAdminListState extends State<SalaryAdminList> {
  late DateTime date;
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EmployeeViewModel>().getEmployee();
    date = context.read<SalaryViewModel>().selectedDate;
    dateController.text = DateFormat('MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingOnly(16, 0, 16, 16, context),
      child: Column(
        children: [
          Container(
            padding: dynamicPaddingSymmetric(0, 10, context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[600]!,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              readOnly: true,
              controller: dateController,
              decoration: InputDecoration(
                contentPadding: dynamicPaddingSymmetric(12, 16, context),
                labelText: 'Filter Bulan',
                labelStyle: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
                suffixIcon: NanyangMonthPicker(
                  controller: dateController,
                  color: ColorTemplate.violetBlue,
                  onDatePicked: (date){
                    context.read<SalaryViewModel>().selectedDate = date;
                    dateController.text = DateFormat('MMMM yyyy').format(date);
                    context.read<SalaryViewModel>().getEmployee();
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: dynamicHeight(16, context)),
          Expanded(
            child: Selector<SalaryViewModel, List<EmployeeModel>>(
              selector: (context, viewmodel) =>
                  viewmodel.employeeList.where((element) => element.position.type == widget.type).toList(),
              builder: (context, employee, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<SalaryViewModel>().getEmployee();
                  },
                  child: employee.isEmpty
                      ? const Center(child: NanyangEmptyPlaceholder())
                      : ListView.builder(
                    itemCount: employee.length,
                    itemBuilder: (context, index) {
                      return SalaryAdminCard(model: employee[index]);
                    },
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}