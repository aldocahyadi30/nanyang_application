import 'package:nanyang_application/model/announcement_category.dart';
import 'package:nanyang_application/model/employee.dart';

class AnnouncementModel {
  final int id;
  String title;
  String content;
  DateTime? postDate;
  int duration;
  bool isSend;
  int status;
  EmployeeModel employee;
  AnnouncementCategoryModel category;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.postDate,
    this.duration = 0,
    this.isSend = false,
    this.status = 0,
    required this.employee,
    required this.category,
  });

  factory AnnouncementModel.fromSupabase(Map<String, dynamic> announcement) {
    return AnnouncementModel(
      id: announcement['id_pengumuman'],
      title: announcement['judul'],
      content: announcement['isi'],
      postDate: announcement['waktu_kirim'] != null ? DateTime.parse(announcement['waktu_kirim']) : null,
      duration: int.parse(announcement['durasi']),
      isSend: announcement['sudah_kirim'],
      status: announcement['status'],
      employee: EmployeeModel.fromSupabase(announcement['karyawan']),
      category: AnnouncementCategoryModel.fromSupabase(announcement['pengumuman_kategori']),
    );
  }

  static List<AnnouncementModel> fromSupabaseList(List<Map<String, dynamic>> announcements) {
    return announcements.map((announcement) => AnnouncementModel.fromSupabase(announcement)).toList();
  }

  factory AnnouncementModel.empty() {
    return AnnouncementModel(
      id: 0,
      title: '',
      content: '',
      postDate: null,
      duration: 0,
      employee: EmployeeModel.empty(),
      category: AnnouncementCategoryModel.empty(),
    );
  }

  factory AnnouncementModel.copyWith(AnnouncementModel announcement) {
    return AnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      content: announcement.content,
      postDate: announcement.postDate,
      duration: announcement.duration,
      isSend: announcement.isSend,
      status: announcement.status,
      employee: announcement.employee,
      category: announcement.category,
    );
  }
}
