import 'package:flutter/foundation.dart';

class HolidayModel {
  int id;
  String name;
  DateTime date;
  bool isHoliday;

  HolidayModel({
    required this.id,
    required this.name,
    required this.date,
    required this.isHoliday,
  });

  factory HolidayModel.fromSupabase(List<Map<String, dynamic>> holidayDB, dynamic api) {
    List<String> apiDateComponents = api['holiday_date'].split('-');
    apiDateComponents[2] = apiDateComponents[2].padLeft(2, '0');
    String formattedDate = apiDateComponents.join('-');

    if (holidayDB.isNotEmpty) {
      for (var i = 0; i < holidayDB.length; i++) {
        Map<String, dynamic> db = holidayDB[i];
        if (db['tanggal'] == formattedDate) {
          return HolidayModel(
            id: db['id_hari'],
            name: db['nama'],
            date: DateTime.parse(db['tanggal']),
            isHoliday: true,
          );
        }
      }
      return HolidayModel(
        id: 0,
        name: api['holiday_name'],
        date: DateTime.parse(formattedDate),
        isHoliday: false,
      );
    } else {
      return HolidayModel(
        id: 0,
        name: api['holiday_name'],
        date: DateTime.parse(formattedDate),
        isHoliday: false,
      );
    }
  }

  static List<HolidayModel> fromSupabaseList(List<Map<String, dynamic>> holidayDB, List<dynamic> holidayAPI) {
    return holidayAPI.map((api) {
      return HolidayModel.fromSupabase(holidayDB, api);
    }).toList();
  }

  //empty holiday
  factory HolidayModel.empty() {
    return HolidayModel(
      id: 0,
      name: '',
      date: DateTime.now(),
      isHoliday: false,
    );
  }
}
