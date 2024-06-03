import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/module/announcement/widget/announcement_card.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardAnnouncement extends StatefulWidget {
  const DashboardAnnouncement({super.key});

  @override
  State<DashboardAnnouncement> createState() => _DashboardAnnouncementState();
}

class _DashboardAnnouncementState extends State<DashboardAnnouncement> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: dynamicPaddingSymmetric(0, 24, context),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pengumuman',
                style: TextStyle(
                  fontSize: dynamicFontSize(20, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            child: Selector<AnnouncementViewModel, List<AnnouncementModel>>(
              selector: (context, viewmodel) => viewmodel.announcementDashboard,
              builder: (context, announcementDashboard, child) {
                return announcementDashboard.isEmpty
                    ? const NanyangEmptyPlaceholder()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return SizedBox(
                                width: constraints.maxWidth,
                                child: CarouselSlider.builder(
                                  itemCount: announcementDashboard.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return AnnouncementCard(model: announcementDashboard[index]);
                                  },
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 0.9,
                                    height: MediaQuery.of(context).size.height * 0.125,
                                    onPageChanged: (index, reason) {
                                      setState(
                                        () {
                                          _current = index;
                                        },
                                      );
                                    },
                                  ),
                                  carouselController: _controller,
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: announcementDashboard.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: dynamicWidth(8, context),
                                  height: dynamicHeight(8, context),
                                  margin: dynamicMargin(8, 8, 4, 4, context),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                                            .withOpacity(_current == entry.key ? 0.9 : 0.4),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}