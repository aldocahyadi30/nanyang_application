import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement.dart';

class AnnouncementListtile extends StatelessWidget {
  final AnnouncementModel model;
  const AnnouncementListtile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    String shortedContent = model.content.length > 30
        ? model.content.substring(0, 30) + '...'
        : model.content;
    return Card(
      child: Row(
        //TODO 1.1: Card still not showing correctly
        children: [
          Container(
            width: 5.0,
            color: Colors.blue,
          ),
          const VerticalDivider(
            color: Colors.transparent,
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                shortedContent,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                model.postDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }
}
