import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/setting/widget/holiday_card.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class HolidayListScreen extends StatefulWidget {
  const HolidayListScreen({super.key});

  @override
  State<HolidayListScreen> createState() => _HolidayListScreenState();
}

class _HolidayListScreenState extends State<HolidayListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Hari Libur',
        isBackButton: true,
        isCenter: true,
      ),
      body: Padding(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Consumer<ConfigurationViewModel>(
          builder: (context, viewmodel, child) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return HolidayCard(model: viewmodel.holiday[index]);
                },
                itemCount: viewmodel.holiday.length);
          },
        ),
      ),
    );
  }
}
