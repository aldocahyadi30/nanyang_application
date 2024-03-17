import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/global/nanyang_appbar.dart';

class SettingConfigurationDetailScreen extends StatefulWidget {
  const SettingConfigurationDetailScreen({super.key});

  @override
  State<SettingConfigurationDetailScreen> createState() =>
      _SettingConfigurationDetailScreenState();
}

class _SettingConfigurationDetailScreenState
    extends State<SettingConfigurationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = data['title'];

    return Scaffold(
      appBar: NanyangAppbar(title: title, isBackButton: true),
      
    );
  }
}