import 'package:flutter/material.dart';

class AnnouncementCreateForm extends StatefulWidget {
  const AnnouncementCreateForm({super.key});

  @override
  State<AnnouncementCreateForm> createState() => _AnnouncementCreateFormState();
}

class _AnnouncementCreateFormState extends State<AnnouncementCreateForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
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
              label: Text('Judul Pengumuman'),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
          ),
          TextFormField(
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
              label: Text('Isi Pengumuman'),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
