import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/management/screen/management_user_screen.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:provider/provider.dart';

class ManagementUserCard extends StatelessWidget {
  final UserModel model;

  const ManagementUserCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final bool isEditable = model.level < context.read<ConfigurationProvider>().user.level;
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
          model.email,
          style: TextStyle(
            fontSize: dynamicFontSize(12, context),
            color: ColorTemplate.periwinkle,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: _userEdit(context, isEditable),
        onTap: () {
          if (isEditable) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManagementUserScreen(
                          type: 'form',
                          model: model,
                        )));
          } else {
            context.read<ToastProvider>().showToast('Anda tidak memiliki akses', 'error');
          }
        },
      ),
    );
  }

  Widget _userEdit(BuildContext context, bool isEditable) {
    if (isEditable) {
      return const Icon(
        Icons.edit,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Icons.lock,
        color: Colors.grey,
      );
    }
  }
}