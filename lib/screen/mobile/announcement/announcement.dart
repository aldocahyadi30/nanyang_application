import 'package:flutter/material.dart';
import 'package:nanyang_application/screen/mobile/announcement/announcement_create.dart';
import 'package:nanyang_application/widget/announcement/announcement_list.dart';
import 'package:nanyang_application/widget/global/nanyang_appbar.dart';
import 'package:nanyang_application/widget/request/request_filter.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController filterController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Pengumuman',
        isBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AnnouncementDetailScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: RequestFilter(controller: filterController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  'List Pengumuman',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt, color: Colors.blue),
                ),
              ),
            ],
          ),
          const Expanded(child: AnnouncementList())
        ],
      ),
    );
  }
}