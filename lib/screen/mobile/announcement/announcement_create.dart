import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/announcement/announcement_create_form.dart';
import 'package:nanyang_application/widget/global/nanyang_appbar.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  const AnnouncementDetailScreen({super.key});

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: NanyangAppbar(
        title: 'Form Pengumuman',
        isBackButton: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: AnnouncementCreateForm(),
      ),),
    );
  }
}