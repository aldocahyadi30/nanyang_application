import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/module/announcement/widget/announcement_card.dart';
import 'package:nanyang_application/module/announcement/widget/announcement_filter.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({super.key});

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementViewModel>().getAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingSymmetric(0, 16, context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SearchAnchor(
                  viewBackgroundColor: ColorTemplate.periwinkle,
                  viewHintText: 'Cari...',
                  dividerColor: ColorTemplate.violetBlue,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                        elevation: WidgetStateProperty.all<double>(0),
                        hintText: 'Cari...',
                        backgroundColor: WidgetStateProperty.all<Color>(ColorTemplate.periwinkle),
                        shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(dynamicWidth(20, context)))),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        trailing: const [
                          Icon(
                            Icons.search,
                            color: ColorTemplate.violetBlue,
                          )
                        ]);
                  },
                  suggestionsBuilder: (BuildContext context, SearchController controller) {
                    String query = controller.text;
                    return context
                        .read<AnnouncementViewModel>()
                        .announcement
                        .where((AnnouncementModel announcement) =>
                            announcement.title.toLowerCase().contains(query.toLowerCase()))
                        .map<Widget>((announcement) => InkWell(
                              onTap: () {},
                              child: Container(
                                margin: dynamicPaddingSymmetric(8, 0, context),
                                padding: dynamicPaddingSymmetric(0, 8, context),
                                child: AnnouncementCard(model: announcement),
                              ),
                            ))
                        .toList();
                  },
                ),
              ),
              SizedBox(
                width: dynamicWidth(16, context),
              ),
              Ink(
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3F51B5), Color(0xFFAAD8F9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: CircleBorder(),
                ),
                child: const AnnouncementFilter(
                  color: Colors.white,
                  size: 32,
                ),
              )
            ],
          ),
          SizedBox(height: dynamicHeight(16, context)),
          Expanded(
            child: Selector<AnnouncementViewModel, List<AnnouncementModel>>(
              selector: (context, viewmodel) => context.read<AuthViewModel>().user.level == 1
                  ? viewmodel.announcement.where((element) => element.isValid == true).toList()
                  : viewmodel.announcement,
              builder: (context, announcement, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AnnouncementViewModel>().getAnnouncement();
                  },
                  child: announcement.isEmpty
                      ? const NanyangEmptyPlaceholder()
                      : ListView.separated(
                          itemCount: announcement.length,
                          itemBuilder: (context, index) {
                            return AnnouncementCard(model: announcement[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) => Divider(
                            color: Colors.transparent,
                            height: dynamicHeight(8, context),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}