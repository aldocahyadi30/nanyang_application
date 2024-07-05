import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/announcement/screen/announcement_form_screen.dart';
import 'package:nanyang_application/module/announcement/widget/announcement_list.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({
    super.key,
  });

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController filterController = TextEditingController();
  late final UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthViewModel>().user;
  }

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorTemplate.lightVistaBlue,
        appBar: const NanyangAppbar(
          title: 'Pengumuman',
          isBackButton: true,
          isCenter: true,
        ),
        floatingActionButton: _user.isAdmin
            ? FloatingActionButton(
                onPressed: () => context.read<AnnouncementViewModel>().create(),
                backgroundColor: ColorTemplate.violetBlue,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              )
            : null,
        body: Column(
          children: [
            SizedBox(
              height: dynamicHeight(8, context),
            ),
            const Expanded(child: AnnouncementList()),
          ],
        ));
  }
}