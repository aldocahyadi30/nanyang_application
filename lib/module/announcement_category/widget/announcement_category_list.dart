import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/module/announcement_category/widget/announcement_category_card.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementCategoryList extends StatefulWidget {
  const AnnouncementCategoryList({super.key});

  @override
  State<AnnouncementCategoryList> createState() => _AnnouncementCategoryListState();
}

class _AnnouncementCategoryListState extends State<AnnouncementCategoryList> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementViewModel>().getAnnouncementCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AnnouncementViewModel, List<AnnouncementCategoryModel>>(
      selector: (context, viewmodel) => viewmodel.announcementCategory,
      builder: (context, announcementCategory, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<AnnouncementViewModel>().getAnnouncementCategory();
          },
          child: announcementCategory.isEmpty
              ? const Center(
                  child: NanyangEmptyPlaceholder(),
                )
              : ListView.builder(
                  itemCount: announcementCategory.length,
                  itemBuilder: (context, index) {
                    return AnnouncementCategoryCard(
                      model: announcementCategory[index],
                    );
                  },
                ),
        );
      },
    );
  }
}