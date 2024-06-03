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
  final bool isSend;
  final int status;

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
    required this.duration,
    this.isSend = false,
    this.status = 0,
  });

  static List<AnnouncementModel> fromSupabaseList(List<Map<String, dynamic>> announcements) {
    return announcements.map((announcement) {
      String colorHex = announcement['pengumuman_kategori']['kode_warna'];
      Color color = Color(int.parse(colorHex));

      return AnnouncementModel(
        id: announcement['id_pengumuman'],
        categoryId: announcement['pengumuman_kategori']['id_kategori'],
        categoryName: announcement['pengumuman_kategori']['nama'],
        categoryColor: color,
        employeeID: announcement['karyawan']['id_karyawan'],
        employeeName: announcement['karyawan']['nama'],
        title: announcement['judul'],
        content: announcement['isi'],
        postDate: announcement['waktu_kirim'] != null ? DateTime.parse(announcement['waktu_kirim']) : null,
        duration: int.parse(announcement['durasi']),
        isSend: announcement['sudah_kirim'],
        status: announcement['status'],
      );
    }).toList();
  }
}
