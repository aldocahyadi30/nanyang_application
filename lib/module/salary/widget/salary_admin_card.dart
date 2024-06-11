import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

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
            model.initials!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Padding(
          padding: dynamicPaddingOnly(0, 4, 0, 0, context),
          child: Text(
            model.shortedName!,
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
          model.position.name,
          style: TextStyle(
            fontSize: dynamicFontSize(12, context),
            color: ColorTemplate.periwinkle,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: _buildTrailing(context, model.thisMonthSalary != null),
        onTap: () async{
          if (model.thisMonthSalary != null) {
            await context.read<SalaryViewModel>().detail(model);
          } else {
            await context.read<SalaryViewModel>().create(model);
          }
        },
      ),
    );
  }
}

CircleAvatar _buildTrailing(BuildContext context, bool isSalaryExist) {
  return CircleAvatar(
    backgroundColor: isSalaryExist ? Colors.green : Colors.red,
    child: Icon(
      isSalaryExist ? Icons.check : Icons.close,
      color: Colors.white,
    ),
  );
}
