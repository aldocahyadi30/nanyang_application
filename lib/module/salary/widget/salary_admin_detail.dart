import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/picker/nanyang_month_picker.dart';
import 'package:nanyang_application/helper.dart';

class SalaryAdminDetail extends StatefulWidget {
  final EmployeeModel model;
  const SalaryAdminDetail({super.key, required this.model});

  @override
  State<SalaryAdminDetail> createState() => _SalaryAdminDetailState();
}

class _SalaryAdminDetailState extends State<SalaryAdminDetail> {
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  type: 'salary-admin',
                  color: ColorTemplate.violetBlue,
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
                  _buildProfileField(context, widget.model),
                  SizedBox(height: dynamicHeight(8, context)),
                  const Divider(color: Colors.grey),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildSalaryDetailField(context),
                  SizedBox(height: dynamicHeight(8, context)),
                  const Divider(color: Colors.grey),
                  SizedBox(height: dynamicHeight(8, context)),
                ],
              ),
            ),
          )
        ],
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
          employee.initials,
          style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context)),
        ),
      ),
      Text(
        employee.shortedName,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(20, context),
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        employee.positionName,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Column _buildSalaryDetailField(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gaji Pokok',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '100.000',
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
            '0',
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
            '0',
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
            '0',
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
            '0',
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
            '100.000',
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
