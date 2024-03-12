import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/widget/request_filter.dart';
import 'package:nanyang_application/widget/request_list.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final TextEditingController filterController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Pengumuman',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[200]!,
                Colors.blue,
                Colors.blue[700]!,
                Colors.blue[800]!
              ],
            ),
          ),
        ),
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/pengumuman/create');
        },
        backgroundColor: Colors.blue,
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
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
          const Expanded(child: RequestList())
        ],
      ),
    );
  }
}
