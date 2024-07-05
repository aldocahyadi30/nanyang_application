import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/model/salary.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_month_picker.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminDetailScreen extends StatefulWidget {
  const SalaryAdminDetailScreen({super.key});

  @override
  State<SalaryAdminDetailScreen> createState() => _SalaryAdminDetailScreenState();
}

class _SalaryAdminDetailScreenState extends State<SalaryAdminDetailScreen> {
  final TextEditingController dateController = TextEditingController();
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = context.read<SalaryViewModel>().selectedDate;
    dateController.text = DateFormat('MMMM yyyy').format(date);
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
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
      body: Consumer<SalaryViewModel>(
        builder: (context, viewmodel, child) {
          return Container(
            padding: dynamicPaddingSymmetric(0, 16, context),
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
                        onDatePicked: (date) {
                          context.read<SalaryViewModel>().selectedDate = date;
                          dateController.text = DateFormat('MMMM yyyy').format(date);
                          context.read<SalaryViewModel>().getSalary();
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: dynamicHeight(16, context)),
                Card(
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    padding: dynamicPaddingSymmetric(16, 16, context),
                    child: Column(
                      children: [
                        _buildProfileField(context, viewmodel.employee),
                        SizedBox(height: dynamicHeight(8, context)),
                        const Divider(color: Colors.grey),
                        SizedBox(height: dynamicHeight(8, context)),
                        _buildSalaryVariableField(context, viewmodel.employee, viewmodel.salary),
                        SizedBox(height: dynamicHeight(8, context)),
                        const Divider(color: Colors.grey),
                        SizedBox(height: dynamicHeight(8, context)),
                        _buildSalaryDetailField(context, viewmodel.employee, viewmodel.salary),
                        SizedBox(height: dynamicHeight(8, context)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Column _buildProfileField(BuildContext context, EmployeeModel employee) {
  return Column(
    children: [
      CircleAvatar(
        radius: dynamicWidth(48, context),
        backgroundColor: Colors.black,
        child: Text(
          employee.initials!,
          style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context)),
        ),
      ),
      Text(
        employee.shortedName!,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(20, context),
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        employee.position.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Column _buildSalaryVariableField(BuildContext context, EmployeeModel employee, SalaryModel salary) {
  return Column(
    children: [
      if (employee.position.type == 1)
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jumlah Hari Kerja',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: dynamicFontSize(16, context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                salary.totalWorkingDay.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: dynamicFontSize(16, context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jumlah Hari Masuk',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: dynamicFontSize(16, context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                salary.totalAttendance.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: dynamicFontSize(16, context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ]),
      if (employee.position.type == 2)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Kuota (Gram)',
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              salary.totalGram.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            employee.position.type == 1 ? 'Gaji Pokok' : 'Gaji / 10 Gram',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            formatCurrency(salary.baseSalary),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ],
  );
}

Column _buildSalaryDetailField(BuildContext context, EmployeeModel employee, SalaryModel salary) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gaji Yang Didapatkan',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            employee.position.type == 1
                ? formatCurrency((salary.baseSalary / salary.totalWorkingDay) * salary.totalAttendance)
                : formatCurrency((salary.baseSalary * (salary.totalGram / 10))),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lembur',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            formatCurrency(salary.totalOvertime),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tunjangan',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            formatCurrency(salary.totalBonus),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'BPJS',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            employee.position.type == 1
                ? formatCurrency(salary.baseSalary * (salary.bpjsRate / 100))
                : formatCurrency(salary.baseSalary * salary.totalGram * (salary.bpjsRate / 100)),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Potongan',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "(${formatCurrency(salary.totalDeduction)})",
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      SizedBox(height: dynamicHeight(8, context)),
      const Divider(color: Colors.grey),
      SizedBox(height: dynamicHeight(8, context)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Gaji',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            formatCurrency(salary.totalSalary),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ],
  );
}