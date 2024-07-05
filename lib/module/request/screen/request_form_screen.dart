import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
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
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestFormScreen extends StatefulWidget {
  final int type;

  const RequestFormScreen({super.key, required this.type});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController timeController1 = TextEditingController();
  final TextEditingController timeController2 = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late RequestViewModel _requestViewModel;
  late RequestModel model;
  bool isLoading = false;
  bool isEdit = false;
  int selectedAttendance = 1;

  @override
  void initState() {
    super.initState();
    _requestViewModel = Provider.of<RequestViewModel>(context, listen: false);
    if (_requestViewModel.selectedRequest.id == 0) {
      model = _requestViewModel.selectedRequest;
      model.type = widget.type;
    } else {
      model = RequestModel.copyWith(_requestViewModel.selectedRequest);
    }

    if (model.id != 0) {
      isEdit = true;
      if (widget.type == 1 || widget.type == 2 || widget.type == 3) {
        selectedAttendance = widget.type;
      } else {}
      reasonController.text = model.reason ?? '';
      if (model.file != null) {
        fileController.text = model.filePath!.split('/').last;
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
    timeController1.dispose();
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
      model.reason = reasonController.text;
      if (selectedAttendance == 1 || selectedAttendance == 2) {
        if (DateTime.now().isAfter(model.startDateTime!)) {
          context
              .read<ToastProvider>()
              .showToast('Waktu izin tidak boleh melebihi waktu saat ini!', 'error');
          setState(() {
            isLoading = false;
          });
          return;
        }
      } else if (selectedAttendance == 7) {
        startDate = dateController.text;
        startTime = timeController1.text;
        endTime = timeController2.text;
        model.startDateTime = parseStringToDateFormattedWithTime('$startDate $startTime');
        model.endDateTime = parseStringToDateFormattedWithTime('$startDate $endTime');
      } else {
        startTime = '00:00';
        endTime = '23:59';
        List<String> dateRange = dateRangeController.text.split(' - ');
        startDate = dateRange[0];
        endDate = dateRange[1];
        model.startDateTime = parseStringToDateFormattedWithTime('$startDate $startTime');
        model.endDateTime = parseStringToDateFormattedWithTime('$endDate $endTime');
      }
      if (isEdit) {
        await _requestViewModel.update(model);
      } else {
        await _requestViewModel.store(model);
      }

      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Perizinan',
        isCenter: true,
        isBackButton: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - keyboardHeight,
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
                        onChanged: (value) {
                          setState(() {
                            selectedAttendance = value!;
                            model.type = value;
                          });
                        },
                      )
                    : Container(),
                SizedBox(height: dynamicHeight(16, context)),
                _buildDateTimeField(
                    context, widget.type, dateController, dateRangeController, timeController1, timeController2, model),
                SizedBox(height: dynamicHeight(16, context)),
                FormTextField(
                  title: 'Alasan',
                  controller: reasonController,
                  maxLines: 5,
                ),
                SizedBox(height: dynamicHeight(16, context)),
                if (widget.type != 7)
                  FormPickerField(
                    title: widget.type == 5 || widget.type == 6 ? 'Surat Dokter' : 'File (Opsional)',
                    isRequired: widget.type == 5 || widget.type == 6 ? true : false,
                    picker: NanyangFilePicker(
                      onFilePicked: (file) {
                        setState(() {
                          fileController.text = file.path.split('/').last;
                          model.filePath = file.path;
                          model.file = file;
                        });
                      },
                    ),
                    controller: fileController,
                  ),
                SizedBox(height: dynamicHeight(32, context)),
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
  } else if (type == 7) {
    requestType = 'Lembur';
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

Widget _buildDateTimeField(
    BuildContext context,
    int type,
    TextEditingController dateController,
    TextEditingController dateRangeController,
    TextEditingController timeController1,
    TextEditingController timeController2,
    RequestModel model) {
  if (type == 1) {
    return Column(children: [
      FormPickerField(
        title: 'Tanggal',
        picker: NanyangDatePicker(
          selectedDate: model.startDateTime,
          firstDate: DateTime.now(),
          onDatePicked: (date) {
            dateController.text = DateFormat('dd/MM/yyyy').format(date);
            if (dateController.text.isNotEmpty && timeController1.text.isNotEmpty) {
              model.startDateTime =
                  parseStringToDateFormattedWithTime('${dateController.text} ${timeController1.text}');
            }
          },
        ),
        controller: dateController,
      ),
      SizedBox(height: dynamicHeight(16, context)),
      FormPickerField(
        title: 'Jam Masuk',
        picker: NanyangTimePicker(
          selectedTime: model.startDateTime != null
              ? TimeOfDay(hour: model.startDateTime!.hour, minute: model.startDateTime!.minute)
              : null,
          onTimePicked: (time) {
            timeController1.text = time.format(context);
            if (dateController.text.isNotEmpty && timeController1.text.isNotEmpty) {
              model.startDateTime =
                  parseStringToDateFormattedWithTime('${dateController.text} ${timeController1.text}');
            }
          },
        ),
        controller: timeController1,
      ),
    ]);
  } else if (type == 2) {
    return Column(children: [
      FormPickerField(
        title: 'Tanggal',
        picker: NanyangDatePicker(
          selectedDate: model.startDateTime,
          firstDate: DateTime.now(),
          onDatePicked: (date) {
            dateController.text = DateFormat('dd/MM/yyyy').format(date);
            if (dateController.text.isNotEmpty && timeController1.text.isNotEmpty) {
              model.startDateTime =
                  parseStringToDateFormattedWithTime('${dateController.text} ${timeController1.text}');
            }
          },
        ),
        controller: dateController,
      ),
      SizedBox(height: dynamicHeight(16, context)),
      FormPickerField(
        title: 'Jam Pulang',
        picker: NanyangTimePicker(
          selectedTime: model.startDateTime != null
              ? TimeOfDay(hour: model.startDateTime!.hour, minute: model.startDateTime!.minute)
              : null,
          onTimePicked: (time) {
            timeController1.text = time.format(context);
            if (dateController.text.isNotEmpty && timeController1.text.isNotEmpty) {
              model.startDateTime =
                  parseStringToDateFormattedWithTime('${dateController.text} ${timeController1.text}');
            }
          },
        ),
        controller: timeController1,
      ),
    ]);
  } else if (type == 7) {
    return Column(children: [
      FormPickerField(
        title: 'Tanggal',
        picker: NanyangDatePicker(
          selectedDate: model.startDateTime,
          firstDate: DateTime.now(),
          onDatePicked: (date) {
            dateController.text = DateFormat('dd/MM/yyyy').format(date);
            if (dateController.text.isNotEmpty && timeController1.text.isNotEmpty) {
              model.startDateTime =
                  parseStringToDateFormattedWithTime('${dateController.text} ${timeController1.text}');
            }

            if (dateController.text.isNotEmpty && timeController2.text.isNotEmpty) {
              model.endDateTime = parseStringToDateFormattedWithTime('${dateController.text} ${timeController2.text}');
            }
          },
        ),
        controller: dateController,
      ),
      SizedBox(height: dynamicHeight(16, context)),
      FormPickerField(
        title: 'Jam Mulai',
        picker: NanyangTimePicker(
          selectedTime: model.startDateTime != null
              ? TimeOfDay(hour: model.startDateTime!.hour, minute: model.startDateTime!.minute)
              : null,
          onTimePicked: (time) {
            timeController1.text = time.format(context);
            if (dateController.text.isNotEmpty && timeController1.text.isNotEmpty) {
              model.startDateTime =
                  parseStringToDateFormattedWithTime('${dateController.text} ${timeController1.text}');
            }
          },
        ),
        controller: timeController1,
      ),
      SizedBox(height: dynamicHeight(16, context)),
      FormPickerField(
        title: 'Jam Selesai',
        picker: NanyangTimePicker(
          selectedTime: model.endDateTime != null
              ? TimeOfDay(hour: model.endDateTime!.hour, minute: model.endDateTime!.minute)
              : null,
          onTimePicked: (time) {
            timeController2.text = time.format(context);

            if (dateController.text.isNotEmpty && timeController2.text.isNotEmpty) {
              model.endDateTime = parseStringToDateFormattedWithTime('${dateController.text} ${timeController2.text}');
            }
          },
        ),
        controller: timeController2,
      ),
    ]);
  } else {
    return FormPickerField(
      title: 'Tanggal',
      picker: NanyangDateRangePicker(
        selectedDateRange:
            model.startDateTime != null ? DateTimeRange(start: model.startDateTime!, end: model.endDateTime!) : null,
        onDateRangePicked: (dateRange) {
          dateRangeController.text =
              '${DateFormat('dd/MM/yyyy').format(dateRange.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange.end)}';

          if (dateRangeController.text.isNotEmpty) {
            model.startDateTime =
                parseStringToDateFormattedWithTime('${DateFormat('dd/MM/yyyy').format(dateRange.start)} 00:00');
            model.endDateTime =
                parseStringToDateFormattedWithTime('${DateFormat('dd/MM/yyyy').format(dateRange.end)} 23:59');
          }
        },
      ),
      controller: dateRangeController,
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