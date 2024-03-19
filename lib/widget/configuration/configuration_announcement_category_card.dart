import 'package:flutter/material.dart';
import 'package:nanyang_application/model/announcement_category.dart';

class ConfigurationAnnouncementCategoryCard extends StatelessWidget {
  final AnnouncementCategoryModel model;
  const ConfigurationAnnouncementCategoryCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: model.color,
          ),
          title: Text(
            model.name,
            style: const  TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}