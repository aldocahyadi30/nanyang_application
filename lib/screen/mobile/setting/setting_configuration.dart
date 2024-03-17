import 'package:flutter/material.dart';

import '../../../widget/global/nanyang_appbar.dart';
import '../../../widget/setting/setting_configuration_item.dart';

class SettingConfigurationScreen extends StatelessWidget {
  const SettingConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Konfigurasi',
        isBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            SettingConfigurationItem(
              title: 'Pengumuman',
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.category, color: Colors.blue),
                  title: const Text(
                    'Kategori Pengumuman',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  onTap: () {},
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SettingConfigurationItem(
              title: 'Peforma',
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.calculate, color: Colors.blue),
                  title: const Text(
                    'Variabel Perhitungan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  onTap: () {},
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}