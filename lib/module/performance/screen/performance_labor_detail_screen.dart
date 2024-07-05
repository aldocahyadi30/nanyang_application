import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/performance_labor.dart';
import 'package:nanyang_application/model/performance_labor_detail.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/module/performance/widget/performance_labor_card.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/performance_viewmodel.dart';
import 'package:provider/provider.dart';

class PerformanceLaborDetailScreen extends StatefulWidget {
  const PerformanceLaborDetailScreen({super.key});

  @override
  State<PerformanceLaborDetailScreen> createState() => _PerformanceLaborDetailScreenState();
}

class _PerformanceLaborDetailScreenState extends State<PerformanceLaborDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Performa Produksi',
        isCenter: true,
        isBackButton: true,
      ),
      body:  Padding(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Selector<PerformanceViewmodel, List<PerformanceLaborModel>>(
          selector: (context, viewmodel) => viewmodel.laborProductionData,
          builder: (context, production, child) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PerformanceViewmodel>().getLaborProduction();
              },
              child: production.isEmpty
                  ? const Center(child: NanyangEmptyPlaceholder())
                  : ListView.builder(
                itemCount: production.length,
                itemBuilder: (context, index) {
                  return PerformanceLaborCard(model: production[index]);
                },
              ),
            );
          },
        ),
      )
    );
  }
}