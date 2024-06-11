import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_month_picker.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:provider/provider.dart';

class SalaryUserScreen extends StatefulWidget {
  const SalaryUserScreen({super.key});

  @override
  State<SalaryUserScreen> createState() => _SalaryUserScreenState();
}

class _SalaryUserScreenState extends State<SalaryUserScreen> {
  late final ConfigurationProvider _config;
  final TextEditingController dateController = TextEditingController();
  bool isDownloadLoading = false;
  bool isContactLoading = false;

  @override
  void initState() {
    super.initState();
    _config = context.read<ConfigurationProvider>();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Gaji',
        isBackButton: true,
        isCenter: true,
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Column(
          children: [
            Container(
              padding: dynamicPaddingSymmetric(0, 10, context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600]!,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(
                  contentPadding: dynamicPaddingSymmetric(12, 16, context),
                  labelText: 'Filter Bulan',
                  labelStyle: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
                  suffixIcon: NanyangMonthPicker(
                    controller: dateController,
                    type: 'salary-user',
                    color: ColorTemplate.violetBlue,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: dynamicHeight(16, context)),
            Card(
              elevation: 0,
              child: Container(
                width: double.infinity,
                padding: dynamicPaddingSymmetric(16, 16, context),
                child: Column(
                  children: [
                    _buildProfileField(context, _config),
                    SizedBox(height: dynamicHeight(8, context)),
                    const Divider(color: Colors.grey),
                    SizedBox(height: dynamicHeight(8, context)),
                    _buildSalaryDetailField(context),
                    SizedBox(height: dynamicHeight(8, context)),
                    const Divider(color: Colors.grey),
                    SizedBox(height: dynamicHeight(8, context)),
                    Row(
                      children: [
                        Expanded(
                          child: FormButton(
                            text: 'Download',
                            textSize: 12,
                            buttonHeight: 56,
                            isLoading: isDownloadLoading,
                            onPressed: () {},
                            backgroundColor: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: dynamicWidth(16, context),
                        ),
                        Expanded(
                          child: FormButton(
                            text: 'Kontak Admin',
                            textSize: 12,
                            buttonHeight: 56,
                            isLoading: isDownloadLoading,
                            onPressed: () {},
                            backgroundColor: ColorTemplate.violetBlue,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Column _buildProfileField(BuildContext context, ConfigurationProvider config) {
  return Column(
    children: [
      CircleAvatar(
        radius: dynamicWidth(48, context),
        backgroundColor: Colors.black,
        child: Text(
          config.avatarInitials,
          style: TextStyle(color: Colors.white, fontSize: dynamicFontSize(24, context)),
        ),
      ),
      Text(
        config.shortenedName,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(20, context),
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        config.user.employee.position.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Column _buildSalaryDetailField(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gaji Pokok',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '100.000',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lembur',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '0',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tunjangan',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '0',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'BPJS',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '0',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Potongan',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '0',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      SizedBox(height: dynamicHeight(8, context)),
      const Divider(color: Colors.grey),
      SizedBox(height: dynamicHeight(8, context)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Gaji',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '100.000',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    ],
  );
}

