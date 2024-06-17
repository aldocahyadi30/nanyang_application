import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/management/screen/management_user_detail_screen.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserCard extends StatelessWidget {
  final UserModel model;

  const ManagementUserCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final bool isEditable = model.level < context.read<ConfigurationViewModel>().user.level;
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
            model.employee.initials!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Padding(
          padding: dynamicPaddingOnly(0, 4, 0, 0, context),
          child: Text(
            model.employee.shortedName!!,
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
          model.email,
          style: TextStyle(
            fontSize: dynamicFontSize(12, context),
            color: ColorTemplate.periwinkle,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          if (isEditable) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManagementUserDetailScreen(
                          model: model,
                        )));
          } else {
            context.read<ToastProvider>().showToast('Anda tidak memiliki akses', 'error');
          }
        },
      ),
    );
  }
}
