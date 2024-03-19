import 'package:flutter/material.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/widget/configuration/configuration_announcement_category_card.dart';
import 'package:nanyang_application/widget/global/nanyang_header.dart';
import 'package:provider/provider.dart';

class ConfigurationAnnouncementCategoryList extends StatefulWidget {
  const ConfigurationAnnouncementCategoryList({super.key});

  @override
  State<ConfigurationAnnouncementCategoryList> createState() => _ConfigurationAnnouncementCategoryListState();
}

class _ConfigurationAnnouncementCategoryListState extends State<ConfigurationAnnouncementCategoryList> {
  late AnnouncementViewModel _announcementViewModel;

  @override
  void initState() {
    super.initState();
    _announcementViewModel = Provider.of<AnnouncementViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NanyangHeader(title: 'Kategori Pengumuman'),
        FutureBuilder(
          future: _announcementViewModel.getAnnouncementCategory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  const Expanded(
                child:  Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return  const Expanded(
                child:  Center(
                  child: Text('Terjadi kesalahan saat memuat data. Silahkan coba lagi.'),
                ),
              );
            } else {
              if (snapshot.data?.isEmpty ?? true) {
                return const Expanded(
                  child: Center(
                    child: Text('Tidak ada data'),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ConfigurationAnnouncementCategoryCard(model: snapshot.data![index]);
                  },
                );
              }
            }
          },
        )
      ],
    );
  }
}