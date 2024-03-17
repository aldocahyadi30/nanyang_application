import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/model/announcement.dart';

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
        borderRadius: BorderRadius.circular(8), // Set border radius for rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Set shadow color
            blurRadius: 5, // Set the blur radius
            offset: const Offset(0, 2), // Set the offset
          ),
        ],
      ),
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 4,
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        Text(
                          model.categoryName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      model.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '$formattedTime, $formattedDate',
                          style: const TextStyle(
                            fontSize: 12,
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