import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/attendance_user.dart';
import 'package:nanyang_application/helper.dart';

class AttendanceLaborCard extends StatefulWidget {
  final AttendanceUserModel user;

  const AttendanceLaborCard({super.key, required this.user});

  @override
  State<AttendanceLaborCard> createState() => _AttendanceLaborCardState();
}

class _AttendanceLaborCardState extends State<AttendanceLaborCard> {
  bool _isExpanded = false;
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.user.laborDetail == null) {
      _height = dynamicHeight(100, context);
    } else {
      if (widget.user.laborDetail?['status'] == 'Memulai Tugas Baru') {
        _height = dynamicHeight(200, context);
      } else {
        _height = dynamicHeight(100, context);
      }
    }
    String date = DateFormat('EEEE, dd MMMM yyyy').format(widget.user.date);
    return Column(
      children: [
        Padding(
          padding: dynamicPaddingSymmetric(0, 20, context),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              date,
              style: TextStyle(
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w700,
                color: ColorTemplate.violetBlue,
              ),
            ),
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorTemplate.violetBlue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: _buildListTile(context, widget.user, _isExpanded),
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          height: _isExpanded ? _height : 0,
          child: Container(
            decoration: BoxDecoration(
              color: ColorTemplate.lavender,
              borderRadius: BorderRadius.circular(25),
            ),
            child: _buildDetail(context, widget.user),
          ),
        ),
        SizedBox(
          height: dynamicHeight(20, context),
        ),
      ],
    );
  }
}

Widget _buildListTile(BuildContext context, AttendanceUserModel data, bool isExpanded) {
  int status = data.attendance?['inStatus'];

  return ListTile(
    contentPadding: dynamicPaddingSymmetric(0, 16, context),
    leading: status == 0
        ? const CircleAvatar(
            backgroundColor: Colors.red,
            child: FaIcon(
              FontAwesomeIcons.x,
              color: Colors.white,
            ),
          )
        : const CircleAvatar(
            backgroundColor: Colors.green,
            child: FaIcon(
              FontAwesomeIcons.check,
              color: Colors.white,
            ),
          ),
    title: Text(
      status == 0 ? 'Tidak Hadir' : 'Hadir',
      style: TextStyle(
        color: Colors.white,
        fontSize: dynamicFontSize(16, context),
        fontWeight: FontWeight.w600,
      ),
    ),
    subtitle: Text(
      status == 0 ? 'Absensi Belum Terisi' : 'Absensi terisi',
      style: TextStyle(
        color: ColorTemplate.periwinkle,
        fontSize: dynamicFontSize(12, context),
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(
      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
      size: dynamicFontSize(40, context),
      color: ColorTemplate.periwinkle,
    ),
  );
}

Widget _buildDetail(BuildContext context, AttendanceUserModel data) {
  if (data.laborDetail != null) {
    Map<String, dynamic> detail = data.laborDetail!;
    return Column(
      children: [
        detail['status'] == 'Tidak Hadir'
            ? Container(
                decoration: BoxDecoration(
                  color: ColorTemplate.darkVistaBlue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  detail['status'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: dynamicFontSize(16, context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorTemplate.darkVistaBlue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      detail['type'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dynamicFontSize(16, context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorTemplate.darkVistaBlue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      detail['status'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dynamicFontSize(16, context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
        detail['status'] == 'Memulai Tugas Baru'
            ? Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Jumlah Awal: ',
                            style: TextStyle(
                              color: ColorTemplate.darkVistaBlue,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: detail['initialQty'],
                                style: TextStyle(
                                  color: ColorTemplate.violetBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Jumlah Akhir: ',
                            style: TextStyle(
                              color: ColorTemplate.darkVistaBlue,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: detail['finalQty'],
                                style: TextStyle(
                                  color: ColorTemplate.violetBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Berat Awal: ',
                            style: TextStyle(
                              color: ColorTemplate.darkVistaBlue,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: detail['initialWeight'],
                                style: TextStyle(
                                  color: ColorTemplate.violetBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' Kg',
                                style: TextStyle(
                                  color: ColorTemplate.darkVistaBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Berat Awal: ',
                            style: TextStyle(
                              color: ColorTemplate.darkVistaBlue,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: detail['finalWeight'],
                                style: TextStyle(
                                  color: ColorTemplate.violetBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' Kg',
                                style: TextStyle(
                                  color: ColorTemplate.darkVistaBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorTemplate.darkVistaBlue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Nilai Kebersihan: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: detail['cleanScore'],
                                style: TextStyle(
                                  color: ColorTemplate.violetBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' %',
                                style: TextStyle(
                                  color: ColorTemplate.violetBlue,
                                  fontSize: dynamicFontSize(16, context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            : Container()
      ],
    );
  } else {
    return Center(
      child: Padding(
        padding: dynamicPaddingAll(16, context),
        child: Text(
          'Data tidak ada',
          style: TextStyle(
            color: ColorTemplate.darkVistaBlue,
            fontSize: dynamicFontSize(16, context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}