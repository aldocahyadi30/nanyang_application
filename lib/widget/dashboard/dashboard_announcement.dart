import 'package:flutter/material.dart';
import 'package:nanyang_application/service/announcement_service.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';

class DashboardAnnouncement extends StatefulWidget {
  const DashboardAnnouncement({super.key});

  @override
  State<DashboardAnnouncement> createState() => _DashboardAnnouncementState();
}

class _DashboardAnnouncementState extends State<DashboardAnnouncement> {
  late final AnnouncementViewModel _announcementViewModel;

  @override
  void initState() {
    super.initState();
    _announcementViewModel =
        AnnouncementViewModel(announcementService: AnnouncementService());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Pengumuman',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: FutureBuilder(
              future: _announcementViewModel.getDashboardAnnouncement(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data?.isEmpty ?? true) {
                    return const Center(child: Text('Tidak ada pengumuman'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(snapshot.data?[index].title ?? 'No Title'),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
