import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/announcement_category/screen/announcement_category_screen.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/position/screen/position_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_configuration_screen.dart';
import 'package:nanyang_application/module/setting/screen/holiday_list_screen.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../global/other/nanyang_appbar.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Konfigurasi',
        isBackButton: true,
        isCenter: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: dynamicHeight(28, context),
            ),
            _buildConfiguration(
              context,
              'Posisi',
              [
                _buildListTile(context, 'Daftar Posisi', ColorTemplate.vistaBlue, Icons.person_pin, () {
                  context.read<ConfigurationViewModel>().getPosition();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PositionScreen(),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: dynamicHeight(28, context),
            ),
            _buildConfiguration(
              context,
              'Pengumuman',
              [
                _buildListTile(context, 'Kategori Pengumuman', ColorTemplate.vistaBlue, Icons.category, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnnouncementCategoryScreen(
                        isForm: false,
                      ),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: dynamicHeight(28, context),
            ),
            _buildConfiguration(
              context,
              'Performa',
              [
                _buildListTile(context, 'Variabel Perhitungan', ColorTemplate.vistaBlue, Icons.calculate, () {}),
              ],
            ),
            SizedBox(
              height: dynamicHeight(28, context),
            ),
            _buildConfiguration(
              context,
              'Gaji',
              [
                _buildListTile(context, 'Variabel Perhitungan', ColorTemplate.vistaBlue, Icons.calculate, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalaryConfigurationScreen(),
                    ),
                  );
                }),
                SizedBox(height: dynamicHeight(8, context)),
                _buildListTile(context, 'Hari Libur', ColorTemplate.vistaBlue, Icons.calendar_month, () {
                  context.read<ConfigurationViewModel>().getHoliday();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HolidayListScreen(),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: dynamicHeight(28, context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildConfiguration(BuildContext context, String title, List<Widget> children) {
  return Padding(
    padding: dynamicPaddingSymmetric(0, 24, context),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: dynamicPaddingSymmetric(0, 16, context),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ],
    ),
  );
}

Widget _buildListTile(BuildContext context, String title, Color color, IconData icon, Function() onTap) {
  return Container(
    decoration: BoxDecoration(
      color: ColorTemplate.lavender,
      borderRadius: BorderRadius.circular(25),
    ),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: dynamicFontSize(16, context), fontWeight: FontWeight.w600),
      ),
      trailing: Icon(Icons.chevron_right, color: color),
    ),
  );
}
