import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_detail_card.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:provider/provider.dart';

class ManagementEmployeeDetailScreen extends StatelessWidget {
  final EmployeeModel model;
  const ManagementEmployeeDetailScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final ConfigurationProvider _config = context.read<ConfigurationProvider>();
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Karyawan',
        isBackButton: true,
        isCenter: true,
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(8, 16, context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              NanyangDetailCard(
                title: 'Detail Karyawan',
                children: [
                  _buildRow(context, 'Nama', model.shortedName),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Umur', model.age != null ? model.age.toString() : '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Tanggal Lahir', model.birthDate != null ? DateFormat('dd MMMM yyyy').format(model.birthDate!) : '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Tempat Lahir', model.birthPlace ?? '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Alamat', model.address ?? '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Jenis Kelamin', model.gender ?? '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Agama', model.religion ?? '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Nomor Telepon', model.phoneNumber ?? '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'Posisi', model.positionName),
                  SizedBox(height: dynamicHeight(8, context)),
                  _buildRow(context, 'ID Absensi', model.attendanceMachineID != null ? model.attendanceMachineID.toString() : '-'),
                  SizedBox(height: dynamicHeight(8, context)),
                ],
              ),
              Card(
                elevation: 0,
                child: Container(
                  width: double.infinity,
                  padding: dynamicPaddingSymmetric(16, 16, context),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Daftar User',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: dynamicFontSize(20, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: dynamicHeight(16, context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Row _buildRow(BuildContext context, String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Widget _buildUserList(BuildContext context, List<Map<String, dynamic>> users) {
  if (users.isNotEmpty) {
    return ListView.separated(
        itemBuilder: ((context, index) {
          return _buildUserTile(context, users[index]);
        }),
        separatorBuilder: (context, index) => const Divider(
              color: ColorTemplate.periwinkle,
              thickness: 0.5,
            ),
        itemCount: users.length);
  } else {
    return Center(
      child: Text(
        'Tidak ada user',
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

ListTile _buildUserTile(BuildContext context, Map<String, dynamic> user) {
  String level = '';
  if (user['leve'] == 1) {
    level = 'User';
  } else if (user['leve'] == 2) {
    level = 'Admin';
  } else if (user['leve'] == 3) {
    level = 'Super Admin';
  }
  return ListTile(
    title: Text(
      user['email'],
      style: TextStyle(
        color: Colors.black,
        fontSize: dynamicFontSize(16, context),
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(
      level,
      style: TextStyle(
        color: Colors.black,
        fontSize: dynamicFontSize(16, context),
        fontWeight: FontWeight.w400,
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios),
  );
}
