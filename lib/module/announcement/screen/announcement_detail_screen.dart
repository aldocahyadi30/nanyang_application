import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_detail_card.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  const AnnouncementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = context.read<ConfigurationViewModel>().user;
    return Consumer<AnnouncementViewModel>(builder: (context, viewmodel, _) {
      final AnnouncementModel model = viewmodel.selectedAnnouncement;
      return Scaffold(
        appBar: NanyangAppbar(
          title: 'Pengumuman',
          isCenter: true,
          isBackButton: true,
          actions: [
            if (user.isAdmin && !model.isSend)
              IconButton(
                onPressed: () => viewmodel.edit(model),
                icon: const Icon(Icons.edit, color: ColorTemplate.vistaBlue),
              ),
            if (user.isAdmin && model.isSend)
              IconButton(
                onPressed: () => viewmodel.delete(),
                icon: const Icon(Icons.delete, color: ColorTemplate.vistaBlue),
              ),
          ],
        ),
        body: Container(
          padding: dynamicPaddingSymmetric(0, 16, context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                NanyangDetailCard(
                  title: 'Detail Pengumuman',
                  children: [
                    _buildRow(context, 'Judul', model.title),
                    SizedBox(height: dynamicHeight(8, context)),
                    _buildRow(context, 'Kategori', model.category.name),
                    SizedBox(height: dynamicHeight(8, context)),
                    _buildRow(context, 'Waktu Kirim', DateFormat('HH:mm').format(model.postDate!)),
                    SizedBox(height: dynamicHeight(8, context)),
                  ],
                ),
                Card(
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    padding: dynamicPaddingSymmetric(16, 16, context),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Isi Pengumuman',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicFontSize(20, context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: dynamicHeight(16, context)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            model.content,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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