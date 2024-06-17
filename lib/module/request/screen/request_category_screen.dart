import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestCategoryScreen extends StatelessWidget {
  const RequestCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Perizinan',
        isBackButton: true,
        isCenter: true,
      ),
      body: Padding(
        padding: dynamicPaddingSymmetric(8, 16, context),
        child: Column(
          children: [
            _requestCategoryItem(context, 'Izin Kehadiran', 'assets/image/icon/request/izin.png', 1),
            _requestCategoryItem(context, 'Cuti Tahunan', 'assets/image/icon/request/cuti-tahunan.png', 4),
            _requestCategoryItem(context, 'Cuti Sakit', 'assets/image/icon/request/sakit.png', 5),
            _requestCategoryItem(context, 'Cuti Hamil', 'assets/image/icon/request/hamil.png', 6),
            _requestCategoryItem(context, 'Lembur', 'assets/image/icon/request/cuti-tahunan.png', 7),
          ],
        ),
      ),
    );
  }
}

Widget _requestCategoryItem(BuildContext context, String title, String image, int type) {
  return Card(
    color: ColorTemplate.periwinkle,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 4,
    child: ListTile(
        contentPadding: dynamicPaddingSymmetric(8, 16, context),
        title: Text(title, style: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600)),
        leading: Image.asset(image),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => context.read<RequestViewModel>().create(type)),
  );
}
