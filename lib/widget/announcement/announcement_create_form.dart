import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/widget/form/form_picker_field.dart';
import 'package:nanyang_application/widget/form/form_switch_field.dart';
import 'package:nanyang_application/widget/form/form_text_field.dart';
import 'package:nanyang_application/widget/global/datepicker.dart';
import 'package:nanyang_application/widget/global/form_button.dart';
import 'package:nanyang_application/widget/global/timepicker.dart';
import 'package:provider/provider.dart';

class AnnouncementCreateForm extends StatefulWidget {
  const AnnouncementCreateForm({super.key});

  @override
  State<AnnouncementCreateForm> createState() => _AnnouncementCreateFormState();
}

class _AnnouncementCreateFormState extends State<AnnouncementCreateForm> {
  late final AnnouncementViewModel _announcementViewModel;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedCategory;
  bool postLater = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    timeController.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 16.0, vertical: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: FutureBuilder<List<AnnouncementCategoryModel>?>(
                      future: _announcementViewModel.getAnnouncementCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton<int>(
                            value: selectedCategory,
                            items: snapshot.data!.map((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                          );
                        } else {
                          return DropdownButton(items: const [], onChanged: null);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          FormTextField(title: 'Judul Pengumuman', controller: titleController),
          const SizedBox(
            height: 16,
          ),
          FormTextField(title: 'Isi Pengumuman', maxLines: 5, controller: contentController),
          const SizedBox(
            height: 16,
          ),
          FormPickerField(
              title: 'Tanggal Pengumuman',
              picker: Datepicker(controller: dateController, type: 'normal', color: Colors.black),
              controller: dateController),
          const SizedBox(
            height: 16,
          ),
          FormPickerField(
              title: 'Jam Pengumuman',
              picker: Timepicker(controller: timeController, color: Colors.black),
              controller: timeController),
          const SizedBox(
            height: 16,
          ),
          FormSwitchField(
              title: 'Kirim Nanti',
              value: postLater,
              onChanged: (value) {
                setState(() {
                  postLater = value;
                });
              }),
          const SizedBox(
            height: 32,
          ),
          FormButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            text: 'Simpan',
            isLoading: _isLoading,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });

                _announcementViewModel
                    .storeAnnouncement(selectedCategory!, titleController.text, contentController.text, postLater,
                        dateController.text, timeController.text)
                    .then((value) {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                });
              }
            },
          )
        ],
      ),
    );
  }
}