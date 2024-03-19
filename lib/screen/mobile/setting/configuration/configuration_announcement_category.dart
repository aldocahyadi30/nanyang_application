import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/widget/configuration/configuration_announcement_category_form.dart';
import 'package:nanyang_application/widget/configuration/confiiguration_announcement_category_list.dart';
import 'package:nanyang_application/widget/global/nanyang_appbar.dart';

class ConfigurationAnnouncementCategoryScreen extends StatefulWidget {
  final bool isForm;
  final AnnouncementCategoryModel? model;
  const ConfigurationAnnouncementCategoryScreen({super.key, required this.isForm, this.model});

  @override
  State<ConfigurationAnnouncementCategoryScreen> createState() => _ConfigurationAnnouncementCategoryScreenState();
}

class _ConfigurationAnnouncementCategoryScreenState extends State<ConfigurationAnnouncementCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Konfigurasi',
        isBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfigurationAnnouncementCategoryScreen(isForm: true),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child:  widget.isForm ? const ConfigurationAnnouncementCategoryForm() : const ConfigurationAnnouncementCategoryList(),
      ),
    );
  }
}