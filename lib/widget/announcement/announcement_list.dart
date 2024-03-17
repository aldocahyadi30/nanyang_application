import 'package:flutter/material.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/widget/announcement/announcement_listtile.dart';
import 'package:provider/provider.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  late final AnnouncementViewModel _announcementViewModel;

  @override
  void initState() {
    super.initState();
    _announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _announcementViewModel.getAnnouncement(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(
                child: Text('Tidak ada data'),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: AnnouncementListtile(model: snapshot.data![index]),);
                },
              );
            }
          }
        });
  }
}