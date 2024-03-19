import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/model/announcement.dart';
import 'package:nanyang_application/size.dart';

class AnnouncementListtile extends StatelessWidget {
  final AnnouncementModel model;
  const AnnouncementListtile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(model.postDateTime);
    String formattedTime = DateFormat('HH:mm', 'id').format(model.postDateTime);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set the desired color for the card
        borderRadius: BorderRadius.circular(dynamicWidth(8, context)), // Set border radius for rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Set shadow color
            blurRadius: 5, // Set the blur radius
            offset: const Offset(0, 2), // Set the offset
          ),
        ],
      ),
      margin: dynamicMargin(8, 8, 8, 8, context),
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: dynamicPadding(8, 8, 8, 8, context),
          child: Row(
            children: [
              Container(
                height: dynamicHeight(100, context),
                width: dynamicWidth(4, context),
                color: Colors.blue,
              ),
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
                          style: TextStyle(fontSize: dynamicFontSize(16, context), fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        Text(
                          model.categoryName,
                          style: TextStyle(fontSize: dynamicFontSize(14, context), fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
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
                          '$formattedTime, $formattedDate',
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