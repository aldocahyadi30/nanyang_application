import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:nanyang_application/widget/announcement/announcement_listtile.dart';
import 'package:provider/provider.dart';

class DashboardAnnouncement extends StatefulWidget {
  const DashboardAnnouncement({super.key});

  @override
  State<DashboardAnnouncement> createState() => _DashboardAnnouncementState();
}

class _DashboardAnnouncementState extends State<DashboardAnnouncement> {
  // late final AnnouncementViewModel _announcementViewModel;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  late Future<List<AnnouncementModel>> _announcementFuture;

  @override
  void initState() {
    super.initState();
    _announcementFuture = Provider.of<AnnouncementViewModel>(context, listen: false).getDashboardAnnouncement();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: dynamicPadding(0, 0, 20, 20, context),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Pengumuman',
                style: TextStyle(
                  fontSize: dynamicFontSize(20, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: ColorTemplate.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: FutureBuilder(
              future: _announcementFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data?.isEmpty ?? true) {
                    return const Center(child: Text('Tidak ada pengumuman'));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: CarouselSlider.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index, realIndex) {
                              return AnnouncementListtile(model: snapshot.data![index]);
                            },
                            options: CarouselOptions(
                              autoPlay: false,
                              enlargeCenterPage: true,
                              viewportFraction: 0.8,
                              aspectRatio: 2.0,
                              initialPage: 0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            carouselController: _controller,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: snapshot.data!.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: dynamicWidth(8, context),
                                height: dynamicHeight(8, context),
                                margin: dynamicMargin(8, 8, 4, 4, context),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(_current == entry.key ? 0.9 : 0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
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