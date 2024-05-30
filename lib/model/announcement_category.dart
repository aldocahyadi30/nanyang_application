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
      String colorHex = category['kode_warna'];
      Color color = Color(int.parse(colorHex));

      return AnnouncementCategoryModel(
        id: category['id_kategori'],
        name: category['nama'],
        color: color
      );
    }).toList();
  }
}