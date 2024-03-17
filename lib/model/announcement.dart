class AnnouncementModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String title;
  final String content;
  final bool postLater;
  final DateTime postDateTime;

  AnnouncementModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.content,
    required this.postLater,
    required this.postDateTime
  });

  static List<AnnouncementModel> fromSupabaseList(List<Map<String, dynamic>> announcements) {
    return announcements.map((announcement) {
      DateTime postDateTime = DateTime.parse(announcement['post_date'].toString());
      return AnnouncementModel(
        id: announcement['announcement_id'],
        categoryId: announcement['AnnouncementCategory']['category_id'],
        categoryName: announcement['AnnouncementCategory']['name'],
        title: announcement['title'],
        content: announcement['description'],
        postLater: announcement['post_later'],
        postDateTime: postDateTime
      );
    }).toList();
  }
}
