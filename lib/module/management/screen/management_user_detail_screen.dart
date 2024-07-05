import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_detail_card.dart';
import 'package:nanyang_application/module/management/screen/management_user_form_screen.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

enum MenuItem { edit, delete }

class ManagementUserDetailScreen extends StatelessWidget {
  const ManagementUserDetailScreen({super.key});

  void _delete(BuildContext context, UserModel model) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorTemplate.periwinkle,
          title: const Text(
            'Delete',
            style: TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.bold),
          ),
          content: const Text('Apakah anda yakin untuk menghapus user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<AuthViewModel>().delete(model.id).then((value) => Navigator.pop(context));
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserViewModel, UserModel>(
        selector: (context, viewmodel) => viewmodel.selectedUser,
        builder: (context, user, child) {
          return Scaffold(
            backgroundColor: ColorTemplate.periwinkle,
            appBar: NanyangAppbar(
              title: 'User',
              isCenter: true,
              isBackButton: true,
              actions: [
                PopupMenuButton<MenuItem>(
                  color: ColorTemplate.periwinkle,
                  onSelected: (MenuItem result) {
                    if (result == MenuItem.edit) {
                      context.read<UserViewModel>().edit(user);
                    } else if (result == MenuItem.delete) {
                      _delete(context, user);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
                    PopupMenuItem<MenuItem>(
                      value: MenuItem.edit,
                      child: Row(
                        children: [
                          const Icon(Icons.edit, color: ColorTemplate.violetBlue),
                          SizedBox(width: dynamicWidth(16, context)),
                          const Text(
                            'Edit',
                            style: TextStyle(color: ColorTemplate.violetBlue),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem<MenuItem>(
                      value: MenuItem.delete,
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: ColorTemplate.violetBlue),
                          SizedBox(width: dynamicWidth(16, context)),
                          const Text(
                            'Delete',
                            style: TextStyle(color: ColorTemplate.violetBlue),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Container(
              padding: dynamicPaddingSymmetric(0, 16, context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    NanyangDetailCard(
                      title: 'Detail User',
                      children: [
                        _buildRow(context, 'Nama', user.employee.name),
                        SizedBox(height: dynamicHeight(8, context)),
                        _buildRow(context, 'Email', user.email),
                        SizedBox(height: dynamicHeight(8, context)),
                        _buildLevelRow(context, user.level),
                        SizedBox(height: dynamicHeight(8, context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Row _buildRow(BuildContext context, String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Row _buildLevelRow(BuildContext context, int level) {
  String name = '';

  if (level == 1) {
    name = 'User';
  } else if (level == 2) {
    name = 'Admin';
  } else if (level == 3) {
    name = 'Super Admin';
  }

  return _buildRow(context, 'Level', name);
}