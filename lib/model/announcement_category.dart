class AnnouncementCategoryModel {
  final int id;
  final String name;

  AnnouncementCategoryModel({
    required this.id,
    required this.name,
  });

  static List<AnnouncementCategoryModel> fromSupabaseList(List<Map<String, dynamic>> categories) {
    return categories.map((category) {
      return AnnouncementCategoryModel(
        id: category['category_id'],
        name: category['name'],
      );
    }).toList();
  }
}
