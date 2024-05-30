import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/picker/nanyang_color_picker.dart';
import 'package:nanyang_application/provider/color_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementCategoryForm extends StatefulWidget {
  final AnnouncementCategoryModel? model;

  const AnnouncementCategoryForm({super.key, this.model});

  @override
  State<AnnouncementCategoryForm> createState() => _AnnouncementCategoryFormState();
}

class _AnnouncementCategoryFormState extends State<AnnouncementCategoryForm> {
  late final AnnouncementViewModel _announcementViewModel;
  late final ColorProvider _colorProvider;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _colorProvider = Provider.of<ColorProvider>(context, listen: false);
      _announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);

      if (widget.model != null) {
        titleController.text = widget.model!.name;
        _colorProvider.setColor(widget.model!.color);
      } else {
        _colorProvider.setColor(Colors.black);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  Future<void> store() async {
    setState(() {
      _isLoading = true;
    });
    String title = titleController.text;
    String color = _colorProvider.hexColor;
    await _announcementViewModel.storeAnnouncementCategory(title, color).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }

  Future<void> update() async {
    setState(() {
      _isLoading = true;
    });
    String title = titleController.text;
    String color = _colorProvider.hexColor;
    await _announcementViewModel.updateAnnouncementCategory(widget.model!, title, color).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                FormTextField(title: 'Nama Kategori', controller: titleController),
                SizedBox(height: dynamicHeight(24, context)),
                Consumer<ColorProvider>(
                  builder: (context, colorProvider, child) {
                    return FormPickerField(
                        title: 'Warna Kategori',
                        picker: const NanyangColorPicker(
                          color: Color(0xFF7989E2),
                        ),
                        leading:
                            Icon(Icons.circle, color: colorProvider.color, size: dynamicWidth(32, context)),
                        controller: TextEditingController(text: colorProvider.colorName));
                  },
                ),
                SizedBox(height: dynamicHeight(36, context)),
                FormButton(
                  text: 'Simpan',
                  isLoading: _isLoading,
                  backgroundColor: ColorTemplate.lightVistaBlue,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.model != null) {
                        await update();
                      } else {
                        await store();
                      }
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}