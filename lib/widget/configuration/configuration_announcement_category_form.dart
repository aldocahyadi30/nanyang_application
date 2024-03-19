import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/color_provider.dart';
import 'package:nanyang_application/widget/global/colorpicker.dart';
import 'package:nanyang_application/widget/global/nanyang_header.dart';
import 'package:provider/provider.dart';

class ConfigurationAnnouncementCategoryForm extends StatefulWidget {
  const ConfigurationAnnouncementCategoryForm({super.key});

  @override
  State<ConfigurationAnnouncementCategoryForm> createState() => _ConfigurationAnnouncementCategoryFormState();
}

class _ConfigurationAnnouncementCategoryFormState extends State<ConfigurationAnnouncementCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final colorController = TextEditingController();
  final titleController = TextEditingController();

  //TODO fix the color picker
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    colorController.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    return SingleChildScrollView(
        child: Column(
      children: [
        const NanyangHeader(title: 'Form Kategori Pengumuman'),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nama Kategori',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan nama kategori';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.blue,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Warna Kategori',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: TextEditingController(text: colorProvider.hexColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih warna kategori';
                      }
                      return null;
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.blue,
                      prefixIcon: Icon(
                        Icons.square_rounded,
                        color: colorProvider.color,
                        size: 40,
                      ),
                      suffixIcon: const Colorpicker(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ));
  }
}