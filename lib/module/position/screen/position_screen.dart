import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/position/screen/position_form_screen.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class PositionScreen extends StatelessWidget {
  const PositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Posisi',
        isBackButton: true,
        isCenter: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PositionFormScreen(
                type: 'create',
              ),
            ),
          );
        },
        backgroundColor: ColorTemplate.violetBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Consumer<ConfigurationViewModel>(
          builder: (context, viewmodel, child) {
            return ListView.builder(
              itemCount: viewmodel.position.length,
              itemBuilder: (context, index) {
                return Card(
                  color: ColorTemplate.lavender,
                  child: ListTile(
                    title: Text(
                      viewmodel.position[index].name,
                      style: TextStyle(color: ColorTemplate.vistaBlue, fontSize: dynamicFontSize(16, context), fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      viewmodel.selectPosition(viewmodel.position[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PositionFormScreen(type: 'edit'),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
