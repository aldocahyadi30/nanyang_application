import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/module/announcement_category/widget/announcement_category_form.dart';
import 'package:nanyang_application/module/announcement_category/widget/announcement_category_list.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/size.dart';

class AnnouncementCategoryScreen extends StatefulWidget {
  final bool isForm;
  final AnnouncementCategoryModel? model;

  const AnnouncementCategoryScreen({super.key, required this.isForm, this.model});

  @override
  State<AnnouncementCategoryScreen> createState() => _AnnouncementCategoryScreenState();
}

class _AnnouncementCategoryScreenState extends State<AnnouncementCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Kategori',
        isBackButton: true,
        isCenter: true,
      ),
      floatingActionButton: !widget.isForm
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnnouncementCategoryScreen(isForm: true),
                  ),
                );
              },
              backgroundColor: ColorTemplate.violetBlue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Container(
        padding: dynamicPaddingAll(16, context),
        child: widget.isForm
            ? AnnouncementCategoryForm(
                model: widget.model,
              )
            : const AnnouncementCategoryList(),
      ),
    );
  }
}