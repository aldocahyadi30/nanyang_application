import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/viewmodel/performance_viewmodel.dart';
import 'package:provider/provider.dart';

class PerformanceAdminScreen extends StatefulWidget {
  const PerformanceAdminScreen({super.key});

  @override
  State<PerformanceAdminScreen> createState() => _PerformanceAdminScreenState();
}

class _PerformanceAdminScreenState extends State<PerformanceAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.periwinkle,
      appBar: const NanyangAppbar(
        title: 'Performa',
        isBackButton: true,
        isCenter: true,
      ),
      body: Container(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<PerformanceViewmodel>(
                builder: (context, viewmodel, child) {
                  return Card(
                    color: ColorTemplate.violetBlue,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: dynamicPaddingSymmetric(8, 12, context),
                            child: GestureDetector(
                              onTap: () async => context.read<PerformanceViewmodel>().production(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Performa Produksi (Gram)',
                                    style: TextStyle(
                                        fontSize: dynamicFontSize(16, context),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.white)

                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: dynamicPaddingOnly(12, 12, 12, 18, context),
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      color: Colors.blue,
                                      spots: viewmodel.initialQuote,
                                      gradient: const LinearGradient(
                                        colors: [Colors.cyan, Colors.blue],
                                      ),
                                      curveSmoothness: 0.5,
                                      barWidth: 5,
                                      isStrokeCapRound: true,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [Colors.cyan.withOpacity(0.3), Colors.blue.withOpacity(0.3)],
                                        ),
                                      ),
                                    ),
                                    LineChartBarData(
                                      color: Colors.blue,
                                      spots: viewmodel.finalQuote,
                                      gradient: const LinearGradient(
                                        colors: [Colors.pink, Colors.red],
                                      ),
                                      curveSmoothness: 0.5,
                                      barWidth: 5,
                                      isStrokeCapRound: true,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [Colors.pink.withOpacity(0.3), Colors.red.withOpacity(0.3)],
                                        ),
                                      ),
                                    ),
                                  ],
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color: ColorTemplate.periwinkle,
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return const FlLine(
                                        color: ColorTemplate.periwinkle,
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: const Border(
                                      bottom: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                      left: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                      right: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                      top: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                    ),
                                  ),
                                  titlesData: const FlTitlesData(
                                    show: true,
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          interval: 1,
                                          getTitlesWidget: bottomTitleWidgets1),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: leftTitleWidget1,
                                      ),
                                    ),
                                  ),
                                ),
                                duration: const Duration(milliseconds: 150), // Optional
                                curve: Curves.linear,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: dynamicHeight(16, context)),
              Consumer<PerformanceViewmodel>(
                builder: (context, viewmodel, child) {
                  return Card(
                    color: ColorTemplate.violetBlue,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: dynamicPaddingSymmetric(8, 12, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Absensi Karyawan',
                                  style: TextStyle(
                                      fontSize: dynamicFontSize(16, context),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.white)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: dynamicPaddingOnly(12, 12, 12, 18, context),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.4,
                                child: BarChart(
                                  BarChartData(
                                    backgroundColor: ColorTemplate.violetBlue,
                                    barGroups: viewmodel.attendanceeCount,
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      getDrawingHorizontalLine: (value) {
                                        return const FlLine(
                                          color: ColorTemplate.periwinkle,
                                          strokeWidth: 1,
                                        );
                                      },
                                      getDrawingVerticalLine: (value) {
                                        return const FlLine(
                                          color: ColorTemplate.periwinkle,
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: const Border(
                                        bottom: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                        left: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                        right: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                        top: BorderSide(color: ColorTemplate.periwinkle, width: 1),
                                      ),
                                    ),
                                    titlesData: const FlTitlesData(
                                      show: true,
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          interval: 1,
                                          getTitlesWidget: bottomTitleWidgets2,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: leftTitleWidget2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: dynamicHeight(16, context)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget bottomTitleWidgets1(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 12,
    color: ColorTemplate.periwinkle,
  );
  Widget text;

  text = Text(value.toInt().toString(), style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidget1(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 12,
    color: ColorTemplate.periwinkle,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(value.toInt().toString(), style: style),
  );
}

Widget bottomTitleWidgets2(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 12,
    color: ColorTemplate.periwinkle,
  );
  Widget text;

  text = Text(value.toInt().toString(), style: style);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidget2(double value, TitleMeta meta) {
  const style = TextStyle(
    fontSize: 12,
    color: ColorTemplate.periwinkle,
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(value.toInt().toString(), style: style),
  );
}