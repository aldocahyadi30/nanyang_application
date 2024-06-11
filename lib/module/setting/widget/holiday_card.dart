import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/holiday.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class HolidayCard extends StatelessWidget {
  final HolidayModel model;
  const HolidayCard({super.key, required this.model});

  Future<void> update(BuildContext context, int type) async {
    bool isSave = type == 1;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(model.name),
          content: Text('Apakah perusahaan ${isSave ? 'libur' : 'tidak jadi libur'} pada tanggal ${DateFormat('dd MMMM yyyy').format(model.date)}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                context.read<ConfigurationViewModel>().updateHoliday(type);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorTemplate.lavender,
      child: ClipRRect(
        child: Banner(
          message: model.isHoliday ? 'Libur' : 'Kerja',
          color: model.isHoliday ? Colors.green : Colors.red,
          location: BannerLocation.topEnd,
          child: ListTile(
            title: Text(
              model.name,
              style: const TextStyle(color: ColorTemplate.vistaBlue, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('dd MMMM yyyy').format(model.date),
              style: const TextStyle(color: ColorTemplate.vistaBlue),
            ),
            onTap: () {
              context.read<ConfigurationViewModel>().selectHoliday(model);
              update(context, model.isHoliday ? 2 : 1);
            },
          ),
        ),
      ),
    );
  }
}
