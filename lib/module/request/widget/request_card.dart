import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/request/screen/request_detail_screen.dart';
import 'package:nanyang_application/module/request/screen/request_form_screen.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatelessWidget {
  final RequestModel model;
  const RequestCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final EmployeeViewModel employeeViewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    final String avatarText = employeeViewModel.getAvatarInitials(model.requesterName);
    final String employeeName = employeeViewModel.getShortenedName(model.requesterName);

    return Card(
        child: ListTile(
          contentPadding: dynamicPaddingSymmetric(4, 16, context),
          leading: CircleAvatar(
            radius: dynamicWidth(30, context),
            backgroundColor: Colors.black,
            child: Text(
              avatarText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            employeeName,
            style:  TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: _buildSub(context, model.type, startDate: model.startDateTime, endDate: model.endDateTime),
          trailing: _buildTrailing(context, model.status),
          onTap: () {
            redirect(context, model);
          },
        )
    );
  }
}

void redirect(BuildContext context, RequestModel model){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RequestDetailScreen(
        model: model,
      ),
    ),
  );
}

Widget _buildSub(BuildContext context, int type, {DateTime? startDate, DateTime? endDate}){
  String typeName = '';
  String dateTime = '';
  if (type == 1) {
    typeName = 'Izin Telat';
    dateTime = DateFormat('dd MMMM yyyy').format(startDate!);
  }else if (type == 2){
    typeName = 'Izin Pulang Cepat';
    dateTime = DateFormat('dd/MMMM/yyyy HH:ii').format(startDate!);
  }else if (type == 3){
    typeName = 'Izin Tidak Masuk';
    dateTime = '${DateFormat('dd MMMM yyyy').format(startDate!)} - ${DateFormat('dd MMMM yyyy').format(endDate!)}';
  }else if (type == 4){
    typeName = 'Cuti Tahunan';
    dateTime = '${DateFormat('dd MMMM yyyy').format(startDate!)} - ${DateFormat('dd MMMM yyyy').format(endDate!)}';
  }else if (type == 5){
    typeName = 'Cuti Sakit';
    if (endDate != null){
      dateTime = '${DateFormat('dd MMMM yyyy').format(startDate!)} - ${DateFormat('dd MMMM yyyy').format(endDate)}';
    }else{
      dateTime = DateFormat('dd MMMM yyyy').format(startDate!);
    }
  }else if (type == 6){
    typeName = 'Cuti Melahirkan';
    dateTime = '${DateFormat('dd MMMM yyyy').format(startDate!)} - ${DateFormat('dd MMMM yyyy').format(endDate!)}';
  }
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        typeName,
        style:  TextStyle(
          color: ColorTemplate.violetBlue,
          fontSize: dynamicFontSize(12, context),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(width: dynamicHeight(8, context)),
      Text(
        dateTime,
        style:  TextStyle(
          color: Colors.grey,
          fontSize: dynamicFontSize(12, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    ]
  );
}

CircleAvatar _buildTrailing(BuildContext context, int status){
  if (status == 0){
   return const CircleAvatar(
     backgroundColor: Colors.yellow,
     child: FaIcon(
       FontAwesomeIcons.solidHourglassHalf,
       color: Colors.black,
     )
   );
  }else if (status == 1){
    return const CircleAvatar(
        backgroundColor: Colors.green,
        child: FaIcon(
          FontAwesomeIcons.check,
          color: Colors.white,
        )
    );
  }else{
    return const CircleAvatar(
        backgroundColor: Colors.red,
        child: FaIcon(
          FontAwesomeIcons.x,
          color: Colors.white,
        )
    );
  }
}