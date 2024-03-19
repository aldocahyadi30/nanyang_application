import 'dart:ui';

class AnnouncementCategoryModel {
  final int id;
  final String name;
  final Color color;

  AnnouncementCategoryModel({
    required this.id,
    required this.name,
    required this.color,
  });

  static List<AnnouncementCategoryModel> fromSupabaseList(List<Map<String, dynamic>> categories) {
    return categories.map((category) {
      String colorHex = category['color'];
      Color color = Color(int.parse('0xFF$colorHex'));

      return AnnouncementCategoryModel(
        id: category['category_id'],
        name: category['name'],
        color: color
      );
    }).toList();
  }
}