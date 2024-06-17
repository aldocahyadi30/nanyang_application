import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/request/screen/request_form_screen.dart';
import 'package:nanyang_application/module/request/screen/request_screen.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({
    super.key,
  });

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // late RequestViewModel _requestViewModel;
  late UserModel _user;
  bool isLoading = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    // _requestViewModel = Provider.of<RequestViewModel>(context, listen: false);
    _user = Provider.of<ConfigurationViewModel>(context, listen: false).user;
    isAdmin = _user.isAdmin;
  }

  Future<void> response(BuildContext context, String type, RequestViewModel viewmodel) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          bool isTypeApproval = type == 'approve';
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              isTypeApproval ? 'Approve Perizinan' : 'Tolak Perizinan',
              style: TextStyle(color: isTypeApproval ? ColorTemplate.lightVistaBlue : Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: commentController,
                validator: isTypeApproval
                    ? null
                    : (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alasan Penolakan tidak boleh kosong';
                        }
                        return null;
                      },
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: isTypeApproval ? 'Berikan Komentar (Opsional)' : 'Alasan Penolakan (Wajib diisi)',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  contentPadding: dynamicPaddingSymmetric(16, 16, context),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: isTypeApproval ? ColorTemplate.lightVistaBlue : Colors.redAccent),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    if (isTypeApproval) {
                      await viewmodel.response('approve', viewmodel.request.id, commentController.text);
                    } else {
                      await viewmodel.response('reject', viewmodel.request.id, commentController.text);
                    }

                    setState(() {
                      isLoading = false;
                    });
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const RequestScreen(type: 'list')),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: isTypeApproval ? ColorTemplate.lightVistaBlue : Colors.redAccent, foregroundColor: Colors.white),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(isTypeApproval ? 'Approve' : 'Tolak'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> delete() async {}

  Future<void> download() async {}

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestViewModel>(
      builder: (context, viewmodel, child) {
        RequestModel model = viewmodel.selectedRequest;
        bool isClosed = model.approver!.id != 0 || model.rejecter!.id != 0;
        return Scaffold(
          backgroundColor: ColorTemplate.periwinkle,
          appBar: NanyangAppbar(
            title: 'Perizinan',
            isBackButton: true,
            isCenter: true,
            actions: [
              if (!isClosed && !isAdmin)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestFormScreen(
                          type: model.type,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: ColorTemplate.vistaBlue),
                ),
              if (isClosed)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: ColorTemplate.violetBlue),
                ),
            ],
          ),
          body: Container(
            padding: dynamicPaddingSymmetric(0, 16, context),
            child: Column(
              children: [
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
                            'Detail Perizinan',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicFontSize(20, context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: dynamicHeight(16, context)),
                        _buildNameField(context, model.requester.name),
                        SizedBox(height: dynamicHeight(8, context)),
                        _buildTypeField(context, model.type),
                        SizedBox(height: dynamicHeight(8, context)),
                        if (model.type == 1 || model.type == 2 || model.type == 3) _buildAttendanceStatus(context, model.type),
                        SizedBox(height: dynamicHeight(8, context)),
                        _buildDate(context, model),
                      ],
                    ),
                  ),
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
                            'Keterangan',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicFontSize(20, context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: dynamicHeight(16, context)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            model.reason != null ? model.reason! : 'Tidak ada keterangan',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: dynamicFontSize(16, context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.file != null && model.filePath!.isNotEmpty)
                  Card(
                    elevation: 0,
                    child: Container(
                      width: double.infinity,
                      padding: dynamicPaddingOnly(8, 16, 16, 16, context),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'File',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: dynamicFontSize(20, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.download,
                                  color: ColorTemplate.violetBlue,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: dynamicHeight(8, context)),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              model.filePath!.split('/').last,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: dynamicFontSize(16, context),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isClosed && isAdmin)
                  Column(
                    children: [
                      SizedBox(height: dynamicHeight(16, context)),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              height: dynamicHeight(64, context),
                              child: ElevatedButton(
                                  onPressed: () => response(context, 'reject', viewmodel),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: Text(
                                    'Tolak',
                                    style: TextStyle(fontSize: dynamicFontSize(16, context), color: Colors.red, fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: dynamicWidth(16, context),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              height: dynamicHeight(64, context),
                              child: ElevatedButton(
                                  onPressed: () => response(context, 'approve', viewmodel),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorTemplate.lightVistaBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(fontSize: dynamicFontSize(16, context), color: Colors.white, fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (isClosed)
                  Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Container(
                          width: double.infinity,
                          padding: dynamicPaddingOnly(8, 16, 16, 16, context),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Respon Admin',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: dynamicFontSize(20, context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: dynamicHeight(16, context)),
                              _buildResponseField(context, model)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Container(
                          width: double.infinity,
                          padding: dynamicPaddingOnly(8, 16, 16, 16, context),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Komentar Admin',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: dynamicFontSize(20, context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: dynamicHeight(16, context)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  model.comment != null && model.comment!.isNotEmpty ? model.comment! : 'Tidak ada komentar',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: dynamicFontSize(16, context),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        );
      },
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

Widget _buildNameField(BuildContext context, String name) {
  List<String> nameParts = name.split(' ');
  String shortedName = '';

  if (nameParts.length == 1) {
    shortedName = nameParts[0];
  } else if (nameParts.length == 2) {
    shortedName = nameParts.join(' ');
  } else {
    shortedName = nameParts.take(2).join(' ') + nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
  }

  return _buildRow(context, 'Nama', shortedName);
}

Widget _buildTypeField(BuildContext context, int type) {
  String requestType = '';

  if (type == 1 || type == 2 || type == 3) {
    requestType = 'Izin kehadiran';
  } else if (type == 4) {
    requestType = 'Cuti Tahunan';
  } else if (type == 5) {
    requestType = 'Cuti Sakit';
  } else if (type == 6) {
    requestType = 'Cuti Hamil';
  } else if (type == 7) {
    requestType = 'Izin Lembur';
  }

  return _buildRow(context, 'Jenis Perizinan', requestType);
}

Widget _buildAttendanceStatus(BuildContext context, int type) {
  String status = '';
  if (type == 1) {
    status = 'Izin Telat';
  } else if (type == 2) {
    status = 'Izin Pulang Cepat';
  } else if (type == 3) {
    status = 'Izin Tidak Masuk';
  }

  return _buildRow(context, 'Status Kehadira', status);
}

Widget _buildDate(BuildContext context, RequestModel model) {
  if (model.type == 1 || model.type == 2) {
    return Column(
      children: [
        _buildRow(context, 'Tanggal', parseDateToStringFormatted(model.startDateTime!)),
        SizedBox(height: dynamicHeight(8, context)),
        _buildRow(context, model.type == 1 ? 'Jam Masuk' : 'Jam Pulang', parseTimeToString(model.startDateTime!)),
      ],
    );
  } else if (model.type == 7) {
    return Column(
      children: [
        _buildRow(context, 'Tanggal', parseDateToStringFormatted(model.startDateTime!)),
        SizedBox(height: dynamicHeight(8, context)),
        _buildRow(context, 'Jam Lembur', "${parseTimeToString(model.startDateTime!)} - ${parseTimeToString(model.endDateTime!)}"),
      ],
    );
  } else {
    return _buildRow(context, 'Tanggal', "${parseDateToStringFormatted(model.startDateTime!)} - ${parseDateToStringFormatted(model.endDateTime!)}");
  }
}

Column _buildResponseField(BuildContext context, RequestModel model) {
  return Column(
    children: [
      _buildRow(context, 'Admin', model.approver!.id != 0 ? model.approver!.name : model.rejecter!.name),
      SizedBox(height: dynamicHeight(8, context)),
      _buildRow(context, 'Status', model.approver!.id != 0 ? 'Disetujui' : 'Ditolak'),
      SizedBox(height: dynamicHeight(8, context)),
      _buildRow(context, 'Waktu Respon', parseDateToStringWithTime(model.status == 1 ? model.approvalTime! : model.rejectTime!)),
    ],
  );
}
