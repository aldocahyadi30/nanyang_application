import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel model;

  const AnnouncementCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(model.postDate!);
    String formattedTime = DateFormat('HH:mm', 'id').format(model.postDate!);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: model.category.color, width: dynamicWidth(12, context))),
        borderRadius: BorderRadius.circular(dynamicWidth(8, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.read<AnnouncementViewModel>().detail(model),
        child: Padding(
          padding: dynamicPaddingAll(8, context),
          child: Row(
            children: [
              SizedBox(width: dynamicWidth(12, context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.title,
                          style: TextStyle(
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.bold,
                              color: model.category.color),
                        ),
                        Container(
                          padding: dynamicPaddingSymmetric(4, 8, context),
                          decoration: BoxDecoration(
                            color: model.category.color,
                            borderRadius: BorderRadius.circular(dynamicWidth(8, context)),
                          ),
                          child: Text(
                            model.category.name,
                            style: TextStyle(
                                fontSize: dynamicFontSize(14, context),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: dynamicHeight(8, context)),
                    Text(
                      model.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: dynamicFontSize(14, context),
                      ),
                    ),
                    SizedBox(height: dynamicHeight(8, context)),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, size: dynamicFontSize(16, context), color: Colors.grey),
                        SizedBox(width: dynamicWidth(4, context)),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: dynamicFontSize(12, context),
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}