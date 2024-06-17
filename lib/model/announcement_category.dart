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

  factory AnnouncementCategoryModel.fromSupabase(Map<String, dynamic> category) {
    String colorHex = category['kode_warna'];
    Color color = Color(int.parse(colorHex));

    return AnnouncementCategoryModel(
      id: category['id_kategori'],
      name: category['nama'],
      color: color
    );
  }

  static List<AnnouncementCategoryModel> fromSupabaseList(List<Map<String, dynamic>> categories) {
    return categories.map((category) => AnnouncementCategoryModel.fromSupabase(category)).toList();
  }

  factory AnnouncementCategoryModel.empty() {
    return AnnouncementCategoryModel(id: 0, name: '', color: const Color(0xFFFFFFFF));
  }
}