import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_picker_field.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_range_picker.dart';
import 'package:nanyang_application/module/global/picker/nanyang_file_picker.dart';
import 'package:nanyang_application/module/global/picker/nanyang_time_picker.dart';
import 'package:nanyang_application/module/request/screen/request_screen.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestFormScreen extends StatefulWidget {
  final RequestModel? model;
  final int type;

  const RequestFormScreen({super.key, this.model, required this.type});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formResponseKey = GlobalKey<FormState>();
  late RequestViewModel _requestViewModel;
  late ConfigurationProvider _config;
  bool isLoading = false;
  bool isResponseLoading = false;
  bool isEdit = false;
  bool isAdmin = false;
  bool isDisabled = false;
  bool isClosed = false;
  int selectedAttendance = 1;

  @override
  void initState() {
    super.initState();
    _requestViewModel = Provider.of<RequestViewModel>(context, listen: false);
    _config = Provider.of<ConfigurationProvider>(context, listen: false);
    if (widget.model != null) {
      isEdit = !_config.isAdmin;
      isAdmin = _config.isAdmin;
      isClosed = widget.model?.approverId != null || widget.model?.rejecterId != null;
      isDisabled = isAdmin || isClosed;
      if (widget.type == 1 || widget.type == 2 || widget.type == 3) {
        selectedAttendance = widget.model!.type;
      } else {}
      reasonController.text = widget.model!.reason ?? '';
      if (widget.model!.file != null) {
        fileController.text = widget.model!.file!.split('/').last;
      }
    } else {
      if (widget.type == 1 || widget.type == 2 || widget.type == 3) {
        selectedAttendance = widget.type;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    dateRangeController.dispose();
    timeController.dispose();
    reasonController.dispose();
    fileController.dispose();
    commentController.dispose();
  }

  Future<void> storeOrUpdate(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String? startDate;
      String? endDate;
      String? startTime;
      String? endTime;
      String fileName = fileController.text;
      String reason = reasonController.text;
      if (selectedAttendance == 1) {
        startDate = dateController.text;
        startTime = timeController.text;
      } else if (selectedAttendance == 2) {
        startDate = dateController.text;
        startTime = timeController.text;
      } else {
        startTime = '00:00';
        endTime = '23:59';
        List<String> dateRange = dateRangeController.text.split(' - ');
        startDate = dateRange[0];
        endDate = dateRange[1];
      }
      if (isEdit) {
        await _requestViewModel.update(widget.model!, selectedAttendance, reason,
            fileName: fileName, startTime: startTime, endTime: endTime, startDate: startDate, endDate: endDate);
      } else {
        await _requestViewModel.store(widget.type, reason, fileName: fileName, startTime: startTime, endTime: endTime, startDate: startDate, endDate: endDate);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> delete() async {}

  Future<void> download() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: NanyangAppbar(
        title: 'Perizinan',
        isCenter: true,
        isBackButton: true,
        actions: [
          (isAdmin && isClosed) || (isEdit && !isClosed)
              ? IconButton(onPressed: () => delete(), icon: const Icon(Icons.delete, color: ColorTemplate.violetBlue))
              : Container(),
        ],
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: dynamicHeight(16, context)),
                _buildTypeField(context, widget.type),
                SizedBox(height: dynamicHeight(16, context)),
                widget.type == 1 || widget.type == 2 || widget.type == 3
                    ? FormDropdown(
                        title: 'Status Kehadiran',
                        items: const [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('Izin Telat'),
                          ),
                          DropdownMenuItem<int>(
                            value: 2,
                            child: Text('Izin Pulang Cepat'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Izin Tidak Masuk'),
                          ),
                        ],
                        value: selectedAttendance,
                        onChanged: isDisabled
                            ? null
                            : (value) {
                                setState(() {
                                  selectedAttendance = value!;
                                });
                              },
                      )
                    : Container(),
                SizedBox(height: dynamicHeight(16, context)),
                _buildDateTimeField(context, selectedAttendance, dateController, dateRangeController, timeController,
                    isDisabled: isDisabled, model: widget.model),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Alasan',
                  controller: reasonController,
                  maxLines: 5,
                  isReadOnly: isDisabled,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                FormPickerField(
                  title: widget.type == 5 || widget.type == 6 ? 'Surat Dokter' : 'File (Opsional)',
                  isRequired: widget.type == 5 || widget.type == 6 ? true : false,
                  picker: isAdmin
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download,
                            color: ColorTemplate.violetBlue,
                          ),
                        )
                      : NanyangFilePicker(
                          controller: fileController,
                          isDisabled: isDisabled,
                        ),
                  controller: fileController,
                  isDisabled: isDisabled,
                ),
                SizedBox(height: dynamicHeight(32, context)),
                if (isEdit && !isClosed)
                  FormButton(
                    text: isEdit ? 'Update' : 'Buat',
                    isLoading: isLoading,
                    elevation: 8,
                    onPressed: () => storeOrUpdate(context),
                    backgroundColor: ColorTemplate.lightVistaBlue,
                  ),
                SizedBox(height: dynamicHeight(16, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  }

  if (type != 4) {
    return FormTextField(
      title: "Jenis Perizinan",
      initialValue: requestType,
      isReadOnly: true,
      isRequired: false,
    );
  } else {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          flex: 5,
          child: FormTextField(
            title: "Jenis Perizinan",
            initialValue: 'Cuti Tahunan',
            isReadOnly: true,
            isRequired: false,
          ),
        ),
        SizedBox(width: dynamicWidth(8, context)),
        Expanded(
          flex: 1,
          child: _buildLeaveQuote(context, 5),
        ),
      ],
    );
  }
}

Widget _buildDateTimeField(BuildContext context, int selectedAttendance, TextEditingController dateController, TextEditingController dateRangeController,
    TextEditingController timeController,
    {RequestModel? model, bool isDisabled = false}) {
  if (selectedAttendance == 1) {
    return Column(children: [
      FormPickerField(
        title: 'Tanggal',
        picker: NanyangDatePicker(
          type: 'normal',
          controller: dateController,
          selectedDate: model?.startDateTime,
          isDisabled: isDisabled,
        ),
        controller: dateController,
        isDisabled: isDisabled,
      ),
      SizedBox(height: dynamicHeight(16, context)),
      FormPickerField(
        title: 'Jam Masuk',
        picker: NanyangTimePicker(
          controller: timeController,
          selectedTime: model != null ? TimeOfDay(hour: model.startDateTime!.hour, minute: model.startDateTime!.minute) : null,
          isDisabled: isDisabled,
        ),
        controller: timeController,
        isDisabled: isDisabled,
      ),
    ]);
  } else if (selectedAttendance == 2) {
    return Column(children: [
      FormPickerField(
        title: 'Tanggal',
        picker: NanyangDatePicker(
          type: 'normal',
          controller: dateController,
          selectedDate: model?.startDateTime,
          isDisabled: isDisabled,
        ),
        controller: dateController,
        isDisabled: isDisabled,
      ),
      SizedBox(height: dynamicHeight(16, context)),
      FormPickerField(
        title: 'Jam Pulang',
        picker: NanyangTimePicker(
          controller: timeController,
          selectedTime: model != null ? TimeOfDay(hour: model.startDateTime!.hour, minute: model.startDateTime!.minute) : null,
          isDisabled: isDisabled,
        ),
        controller: timeController,
        isDisabled: isDisabled,
      ),
    ]);
  } else {
    return FormPickerField(
      title: 'Tanggal',
      picker: NanyangDateRangePicker(
        controller: dateRangeController,
        type: 'normal',
        selectedDateRange: model != null ? DateTimeRange(start: model.startDateTime!, end: model.endDateTime!) : null,
        isDisabled: isDisabled,
      ),
      controller: dateRangeController,
      isDisabled: isDisabled,
    );
  }
}

Widget _buildLeaveQuote(BuildContext context, int quote) {
  return TextFormField(
    readOnly: true,
    controller: TextEditingController(text: quote.toString()),
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: dynamicFontSize(16, context),
      color: quote > 0 ? ColorTemplate.darkVistaBlue : Colors.red,
      fontWeight: FontWeight.w600,
    ),
    decoration: InputDecoration(
      contentPadding: dynamicPaddingSymmetric(16, 24, context),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(25.0), // Set a consistent border radius
      ),
      filled: true,
      fillColor: ColorTemplate.lavender,
      focusColor: Colors.blue,
    ),
  );
}

Widget _buildResponseField(BuildContext context, RequestModel model) {
  return Column(children: [
    const Divider(
      color: Colors.grey,
      thickness: 1,
    ),
    SizedBox(height: dynamicHeight(16, context)),
    FormTextField(
      title: 'Respon Admin',
      initialValue: model.status == 1 ? 'Diterima' : 'Ditolak',
      isReadOnly: true,
      isRequired: false,
    ),
    SizedBox(height: dynamicHeight(16, context)),
    FormTextField(
      title: 'Admin',
      initialValue: model.status == 1 ? model.approverName : model.rejecterName,
      isReadOnly: true,
      isRequired: false,
    ),
    SizedBox(height: dynamicHeight(16, context)),
    FormTextField(
      title: 'Komentar',
      initialValue: model.comment,
      isReadOnly: true,
      isRequired: false,
      maxLines: 5,
    ),
    SizedBox(height: dynamicHeight(16, context)),
    FormTextField(
      title: 'Waktu Respon',
      initialValue: DateFormat('dd/MM/yyyy HH:mm').format(model.status == 1 ? model.approvalTime! : model.rejectTime!),
      isReadOnly: true,
      isRequired: false,
    ),
  ]);
}
