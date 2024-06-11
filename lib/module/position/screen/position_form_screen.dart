import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/form/form_button.dart';
import 'package:nanyang_application/module/global/form/form_dropdown.dart';
import 'package:nanyang_application/module/global/form/form_text_field.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class PositionFormScreen extends StatefulWidget {
  final String type;
  const PositionFormScreen({super.key, required this.type});

  @override
  State<PositionFormScreen> createState() => _PositionFormScreenState();
}

class _PositionFormScreenState extends State<PositionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedPositionType = 1;
  final TextEditingController _positionNameController = TextEditingController();
  bool _isEdit = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'edit') {
      _isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Posisi',
        isBackButton: true,
        isCenter: true,
      ),
      body: Padding(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Form(
          key: _formKey,
          child: Consumer<ConfigurationViewModel>(
            builder: (context, viewmodel, child) {
              if (_isEdit) {
                _positionNameController.text = viewmodel.selectedPosition.name;
                _selectedPositionType = viewmodel.selectedPosition.type;
              }
              return Column(
                children: [
                  FormTextField(
                    title: 'Nama Posisi',
                    controller: _positionNameController,
                  ),
                  SizedBox(
                    height: dynamicHeight(28, context),
                  ),
                  FormDropdown(
                    title: 'Tipe Posisi',
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Kantor')),
                      DropdownMenuItem(value: 2, child: Text('Produksi')),
                    ],
                    value: _selectedPositionType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPositionType = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: dynamicHeight(28, context),
                  ),
                  FormButton(
                      text: _isEdit ? 'Update' : 'Buat',
                      isLoading: _isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          String name = _positionNameController.text;
                          int type = _selectedPositionType;

                          if (_isEdit) {
                            viewmodel.updatePosition(2, name, type);
                          } else {
                            viewmodel.updatePosition(1, name, type);
                          }
                        }
                      })
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
