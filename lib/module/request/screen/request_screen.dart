import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/request/widget/request_category.dart';
import 'package:nanyang_application/module/request/widget/request_list.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/size.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  final String type;
  final RequestModel? model;

  const RequestScreen({super.key, required this.type, this.model});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController filterController = TextEditingController();
  late final ConfigurationProvider config;
  late final bool isForm;

  @override
  void initState() {
    super.initState();
    config = context.read<ConfigurationProvider>();
    isForm = widget.type == 'create' || widget.type == 'edit';
  }

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isForm ? ColorTemplate.periwinkle : ColorTemplate.lightVistaBlue,
      appBar: NanyangAppbar(
        title: 'Perizinan',
        isCenter: widget.type != 'list' ? true : false,
        isBackButton: widget.type != 'list' ? true : false,
      ),
      floatingActionButton: !config.isAdmin && widget.type == 'list'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestScreen(
                      type: 'category',
                    ),
                  ),
                );
              },
              backgroundColor: ColorTemplate.violetBlue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          SizedBox(
            height: dynamicHeight(20, context),
          ),
          Expanded(child: _buildScreen(type: widget.type)),
        ],
      ),
    );
  }

  Widget _buildScreen({required String type}) {
    if (type == 'list') {
      return const RequestList();
    } else {
      return const RequestCategory();
    }
  }
}