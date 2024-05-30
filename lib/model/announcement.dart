import 'package:flutter/material.dart';

class AnnouncementModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final Color categoryColor;
  final int employeeID;
  final String employeeName;
  final String title;
  final String content;
  final DateTime? postDate;
  final int duration;

  AnnouncementModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.employeeID,
    required this.employeeName,
    required this.title,
    required this.content,
    this.postDate,
    required this.duration
  });

  static List<AnnouncementModel> fromSupabaseList(List<Map<String, dynamic>> announcements) {
    return announcements.map((announcement) {
      DateTime? postDate;
      String colorHex = announcement['pengumuman_kategori']['kode_warna'];
      Color color = Color(int.parse(colorHex));

      if (announcement['waktu_kirim'] != null) {
        postDate = DateTime.parse(announcement['tanggal_post']);
      }
      return AnnouncementModel(
        id: announcement['id_pengumuman'],
        categoryId: announcement['pengumuman_kategori']['id_kategori'],
        categoryName: announcement['pengumuman_kategori']['nama'],
        categoryColor: color,
        employeeID: announcement['karyawan']['id_karyawan'],
        employeeName: announcement['karyawan']['nama'],
        title: announcement['judul'],
        content: announcement['isi'],
        postDate: postDate,
        duration: int.parse(announcement['durasi'])
      );
    }).toList();
  }
}