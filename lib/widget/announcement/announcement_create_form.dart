import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
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
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Judul Pengumuman',
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
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan judul pengumuman';
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
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Isi Pengumuman',
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
                controller: contentController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan isi pengumuman';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tanggal Pengumuman',
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
                controller: dateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan tanggal pengumuman';
                  }
                  return null;
                },
                readOnly: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.blue,
                    suffixIcon: Datepicker(controller: dateController, type: 'normal', color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jam Pengumuman',
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
                controller: timeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan jam pengumuman';
                  }
                  return null;
                },
                readOnly: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.blue,
                    suffixIcon: Timepicker(controller: timeController, color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kirim Nanti?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Switch(
                  value: postLater,
                  activeColor: Colors.blue,
                  onChanged: (bool value) {
                    setState(() {
                      postLater = value;
                    });
                  },
                ),
              )
            ],
          ),
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
                    .storeAnnouncement(selectedCategory!, titleController.text, contentController.text, postLater, dateController.text, timeController.text)
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