import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementFormScreen extends StatefulWidget {
  const AnnouncementFormScreen({super.key});

  @override
  State<AnnouncementFormScreen> createState() => _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState extends State<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AnnouncementViewModel _announcementViewModel;
  late final AnnouncementModel _model;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  bool isLoadingPost = false;
  bool isLoadingSave = false;
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    _announcementViewModel = context.read<AnnouncementViewModel>();
    if (_announcementViewModel.selectedAnnouncement.id != 0) {
      isEdit = true;
      _model = AnnouncementModel.copyWith(_announcementViewModel.selectedAnnouncement);
    } else {
      isEdit = false;
      _model = _announcementViewModel.selectedAnnouncement;
    }

    titleController.text = _model.title;
    contentController.text = _model.content;
    dateController.text = _model.postDate != null ? parseDateToStringFormatted(_model.postDate!) : '';
    timeController.text = _model.postDate != null ? parseTimeToString(_model.postDate!) : '';
    durationController.text = _model.duration.toString();
  }

  Future<void> send() async {
    await showModalBottomSheet(
      elevation: 10,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            padding: dynamicPaddingOnly(16, 0, 16, 16, context),
            decoration: BoxDecoration(
              color: ColorTemplate.periwinkle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dynamicWidth(25, context)),
                topRight: Radius.circular(dynamicWidth(25, context)),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                FormPickerField(
                  hintText: 'Pilih Tanggal',
                  picker: NanyangDatePicker(
                    controller: dateController,
                    selectedDate: _model.postDate,
                    onDatePicked: (date) {
                      dateController.text = parseDateToStringFormatted(date);
                      _model.postDate = date;
                    },
                  ),
                  controller: dateController,
                ),
                SizedBox(
                  height: dynamicHeight(16, context),
                ),
                FormButton(
                  text: 'Buat',
                  isLoading: isLoadingPost,
                  onPressed: () {
                    DateTime now = DateTime.now();
                    if (_model.postDate == null) {
                      bool isToday = _model.postDate!.day == now.day &&
                          _model.postDate!.month == now.month &&
                          _model.postDate!.year == now.year;
                      _model.employee = context.read<AuthViewModel>().user.employee;
                      if (isToday) {
                        _model.status = 1;
                        _model.isSend = true;
                      } else {
                        _model.status = 2;
                        _model.isSend = false;
                      }

                      if (isEdit) {
                        _announcementViewModel.update(_model);
                      } else {
                        _announcementViewModel.store(_model);
                      }
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> save() async {
    _model.status = 0;
    if (isEdit) {
      _announcementViewModel.update(_model);
    } else {
      _announcementViewModel.store(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: NanyangAppbar(
        title: 'Pengumuman',
        isCenter: true,
        isBackButton: true,
        actions: [
          if (_model.status != 1)
            IconButton(
              onPressed: () async {
                await save();
              },
              icon: const Icon(Icons.save, color: ColorTemplate.violetBlue),
            ),
        ],
      ),
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
                      value: _model.category.id != 0 ? _model.category.id : null,
                      onChanged: (value) {
                        setState(() {
                          _model.category = categories.firstWhere((element) => element.id == value);
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Judul Pengumuman',
                  controller: titleController,
                  onChanged: (value) => _model.title = value!,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Isi Pengumuman',
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onChanged: (value) => _model.content = value!,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Durasi Pengumuman',
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _model.duration = int.parse(value!),
                ),
                SizedBox(height: dynamicHeight(32, context)),
                FormButton(
                  text: 'Kirim',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await send();
                      if (mounted){
                        Navigator.pop(context);
                      }
                    }
                  },
                  backgroundColor: ColorTemplate.lightVistaBlue,
                  isLoading: isLoadingPost,
                  elevation: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}