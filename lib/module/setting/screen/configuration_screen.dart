import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/announcement_category/screen/announcement_category_screen.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/position/screen/position_screen.dart';
import 'package:nanyang_application/module/salary/screen/salary_configuration_screen.dart';
import 'package:nanyang_application/module/setting/screen/holiday_list_screen.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool isLloadingSave = false;
  final TextEditingController thresholdController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    thresholdController.dispose();
  }

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
                _buildListTileInput(
                  context,
                  'Batas Performa',
                  context.read<ConfigurationViewModel>().currentConfig.peformanceThreshold.toString(),
                  ColorTemplate.vistaBlue,
                  Icons.calculate,
                  () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      elevation: 10,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            thresholdController.text =
                                context.read<ConfigurationViewModel>().currentConfig.peformanceThreshold.toString();
                            return Container(
                              padding: dynamicPaddingOnly(16, 0, 16, 16, context),
                              decoration: BoxDecoration(
                                color: ColorTemplate.periwinkle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(dynamicWidth(25, context)),
                                  topRight: Radius.circular(dynamicWidth(25, context)),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                children: [
                                  FormTextField(
                                    title: 'Batas Performa',
                                    controller: thresholdController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        thresholdController.text = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: dynamicHeight(16, context),
                                  ),
                                  FormButton(
                                    text: 'Simpan',
                                    isLoading: isLloadingSave,
                                    onPressed: () {
                                      setState(() {
                                        isLloadingSave = true;
                                      });
                                      context.read<ConfigurationViewModel>().updatePerformanceThreshold(
                                            double.parse(thresholdController.text),
                                          );
                                      setState(() {
                                        isLloadingSave = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
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

Widget _buildListTileInput(
    BuildContext context, String title, String value, Color color, IconData icon, Function() onTap) {
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(color: color, fontSize: dynamicFontSize(16, context), fontWeight: FontWeight.w600),
          ),
          Icon(Icons.chevron_right, color: color),
        ],
      ),
    ),
  );
}