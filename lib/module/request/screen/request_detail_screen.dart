import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/request/screen/request_form_screen.dart';
import 'package:nanyang_application/module/request/screen/request_screen.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestDetailScreen extends StatefulWidget {
  final RequestModel model;
  const RequestDetailScreen({super.key, required this.model});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late RequestViewModel _requestViewModel;
  late ConfigurationProvider _config;
  bool isLoading = false;
  bool isAdmin = false;
  bool isClosed = false;

  @override
  void initState() {
    super.initState();
    _requestViewModel = Provider.of<RequestViewModel>(context, listen: false);
    _config = Provider.of<ConfigurationProvider>(context, listen: false);
    isAdmin = _config.isAdmin;
    isClosed = widget.model.approverId != null || widget.model.rejecterId != null;
  }

  Future<void> response(BuildContext context, String type) async {
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
                      await _requestViewModel.response('approve', widget.model!.id, commentController.text);
                    } else {
                      await _requestViewModel.response('reject', widget.model!.id, commentController.text);
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

  @override
  Widget build(BuildContext context) {
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
                      type: widget.model.type,
                      model: widget.model,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.black),
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
                    _buildTypeField(context, widget.model.type),
                    SizedBox(height: dynamicHeight(8, context)),
                    if (widget.model.type == 1 || widget.model.type == 2 || widget.model.type == 3) _buildAttendanceStatus(context, widget.model.type),
                    SizedBox(height: dynamicHeight(8, context)),
                    _buildDate(context, widget.model),
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
                        widget.model.reason != null ? widget.model.reason! : 'Tidak ada keterangan',
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
            if (widget.model.file != null && widget.model.file!.isNotEmpty)
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
                          widget.model.file!.split('/').last,
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
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: dynamicHeight(64, context),
                      child: ElevatedButton(
                          onPressed: () => response(context, 'reject'),
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
                          onPressed: () => response(context, 'approve'),
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
                          _buildResponseField(context, widget.model)
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
                              'Komentar',
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
                              widget.model.comment ?? 'Tidak ada komentar',
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
  }
}

Row _buildTypeField(BuildContext context, int type) {
  String requestType = '';

  if (type == 1 || type == 2 || type == 3) {
    requestType = 'Izin kehadiran';
  } else if (type == 4) {
    requestType = 'Cuti Tahunan';
  } else if (type == 5) {
    requestType = 'Cuti Sakit';
  } else if (type == 6) {
    requestType = 'Cuti Hamil';
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Jenis Perizinan',
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        requestType,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Row _buildAttendanceStatus(BuildContext context, int type) {
  String status = '';
  if (type == 1) {
    status = 'Izin Telat';
  } else if (type == 2) {
    status = 'Izin Pulang Cepat';
  } else if (type == 3) {
    status = 'Izin Tidak Masuk';
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Status Kehadiran',
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        status,
        style: TextStyle(
          color: Colors.black,
          fontSize: dynamicFontSize(16, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

Widget _buildDate(BuildContext context, RequestModel model) {
  if (model.type == 1 || model.type == 2) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tanggal',
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(model.startDateTime!),
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: dynamicHeight(8, context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.type == 1 ? 'Jam Masuk' : 'Jam Pulang',
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat('HH:ii').format(model.startDateTime!),
              style: TextStyle(
                color: Colors.black,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tanggal',
          style: TextStyle(
            color: Colors.black,
            fontSize: dynamicFontSize(16, context),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "${DateFormat('dd/MM/yyyy').format(model.startDateTime!)} - ${DateFormat('dd/MM/yyyy').format(model.endDateTime!)}",
          style: TextStyle(
            color: Colors.black,
            fontSize: dynamicFontSize(16, context),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

Column _buildResponseField(BuildContext context, RequestModel model) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Admin',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            model.approverId != null ? model.approverName! : model.rejecterName!,
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
            'Status',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            model.approverId != null ? 'Disetujui' : 'Ditolak',
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
            'Waktu Respon',
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(model.status == 1 ? model.approvalTime! : model.rejectTime!),
            style: TextStyle(
              color: Colors.black,
              fontSize: dynamicFontSize(16, context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ],
  );
}
