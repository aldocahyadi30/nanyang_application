import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/module/global/picker/nanyang_time_picker.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementFormScreen extends StatefulWidget {
  final AnnouncementModel? model;

  const AnnouncementFormScreen({super.key, this.model});

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AnnouncementViewModel _announcementViewModel;
  late final ConfigurationProvider _config;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  bool isLoadingPost = false;
  bool isLoadingSave = false;
  int selectedCategory = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(title: 'Pengumuman', isCenter: true, isBackButton: true),
      body: Padding(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: dynamicHeight(16, context)),
                Selector<AnnouncementViewModel, List<AnnouncementCategoryModel>>(
                  selector: (context, model) => model.announcementCategory,
                  builder: (context, categories, _) {
                    return FormDropdown(
                      title: 'Kategori Pengumuman',
                      items: categories.isEmpty
                          ? []
                          : categories.map((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                      value: widget.model?.categoryName,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Judul Pengumuman',
                  controller: titleController,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Isi Pengumuman',
                  controller: contentController,
                  maxLines: 5,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormPickerField(
                  title: 'Tanggal Pengumuman',
                  picker: NanyangDatePicker(
                    controller: dateController,
                    type: 'normal',
                    selectedDate: widget.model?.postDate,
                  ),
                  controller: dateController,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormPickerField(
                  title: 'Jam Pengumuman',
                  picker: NanyangTimePicker(
                    controller: timeController,
                    selectedTime: widget.model != null
                        ? TimeOfDay(hour: widget.model!.postDate!.hour, minute: widget.model!.postDate!.minute)
                        : null,
                  ),
                  controller: timeController,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Durasi Pengumuman',
                  controller: durationController,
                  type: TextInputType.number,
                ),
                SizedBox(height: dynamicHeight(32, context)),
                Row(
                  children: [
                    Expanded(
                      child: FormButton(
                        text: 'Simpan',
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        foregroundColor: ColorTemplate.lightVistaBlue,
                        textColor: ColorTemplate.lightVistaBlue,
                        isLoading: isLoadingSave,
                        elevation: 8,
                      ),
                    ),
                    SizedBox(width: dynamicWidth(16, context)),
                    Expanded(
                      child: FormButton(
                        text: 'Kirim',
                        onPressed: () {},
                        backgroundColor: ColorTemplate.lightVistaBlue,
                        isLoading: isLoadingPost,
                        elevation: 8,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}