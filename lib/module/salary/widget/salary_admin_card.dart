import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/salary/screen/salary_admin_screen.dart';
import 'package:nanyang_application/size.dart';

class SalaryAdminCard extends StatelessWidget {
  final EmployeeModel model;
  const SalaryAdminCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorTemplate.violetBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: dynamicPaddingSymmetric(8, 16, context),
        leading: CircleAvatar(
          radius: dynamicWidth(24, context),
          backgroundColor: ColorTemplate.argentinianBlue,
          child: Text(
            model.initials,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Padding(
          padding: dynamicPaddingOnly(0, 4, 0, 0, context),
          child: Text(
            model.shortedName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        subtitle: Text(
          model.positionName,
          style: TextStyle(
            fontSize: dynamicFontSize(12, context),
            color: ColorTemplate.periwinkle,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalaryAdminScreen(
                model: model,
              ),
            ),
          );
        },
      ),
    );
  }
}
