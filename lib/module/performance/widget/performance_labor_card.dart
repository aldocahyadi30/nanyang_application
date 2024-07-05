import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/performance_labor.dart';
import 'package:nanyang_application/model/performance_labor_detail.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:provider/provider.dart';

class PerformanceLaborCard extends StatefulWidget {
  final PerformanceLaborModel model;

  const PerformanceLaborCard({super.key, required this.model});

  @override
  State<PerformanceLaborCard> createState() => _PerformanceLaborCardState();
}

class _PerformanceLaborCardState extends State<PerformanceLaborCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          color: ColorTemplate.violetBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: ListTile(
            contentPadding: dynamicPaddingSymmetric(8, 16, context),
            leading: CircleAvatar(
              radius: dynamicWidth(24, context),
              backgroundColor: ColorTemplate.argentinianBlue,
              child: Text(
                widget.model.employee.initials!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              widget.model.employee.shortedName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: dynamicFontSize(16, context),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              widget.model.avgPerformance.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: dynamicFontSize(14, context),
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: _buildTrailing(context, widget.model.avgPerformance),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        SizedBox(
          height: dynamicHeight(8, context),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          height: _isExpanded ? dynamicHeight(480, context) : 0,
          child: _buildDetail(context, widget.model.performanceLaborDetail),
        )
      ],
    );
  }
}

Column _buildDetail(BuildContext context, List<PerformanceLaborDetailModel> models) {
  List<DateTime> days = [];
  DateTime now = DateTime.now();

  DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

  for (int i = 0; i < 6; i++) {
    DateTime day = firstDayOfWeek.add(Duration(days: i));
    days.add(day);
  }
  double performanceThreshold = context.read<ConfigurationViewModel>().currentConfig.peformanceThreshold;

  List<Widget> cards = [];
  for (int i = 0; i < days.length; i++) {
    PerformanceLaborDetailModel? model = models.firstWhere(
        (element) => parseDateToString(element.date) == parseDateToString(days[i]),
        orElse: () => PerformanceLaborDetailModel(date: days[i], performance: 0));
    late Color colors;
    late IconData icons;

    if (model.performance != 0 && model.performance < performanceThreshold - 1) {
      colors = Colors.redAccent;
      icons = Icons.arrow_circle_down;
    } else if (model.performance != 0 && model.performance > performanceThreshold + 1) {
      colors = Colors.lightGreenAccent;
      icons = Icons.arrow_circle_up;
    } else if (model.performance == 0) {
      colors = Colors.grey[300]!;
      icons = Icons.arrow_circle_right_outlined;
    } else {
      colors = Colors.grey[300]!;
      icons = Icons.arrow_circle_right_outlined;
    }
    cards.add(
      Card(
        color: colors,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            title: Text(
              parseDateToStringFormatted(days[i]),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(model.performance.toString()),
            trailing: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                icons,
                color: Colors.black,
              ),
            )),
      ),
    );

    cards.add(SizedBox(
      height: dynamicHeight(8, context),
    ));
  }

  return Column(
    children: cards,
  );
}

CircleAvatar _buildTrailing(BuildContext context, double value) {
  late Color colors;
  late Color iconColor;
  late IconData icons;
  double performanceThreshold = context.read<ConfigurationViewModel>().currentConfig.peformanceThreshold;

  if (value != 0 && value < performanceThreshold - 1) {
    colors = Colors.redAccent;
    iconColor = Colors.white;
    icons = Icons.arrow_downward;
  } else if (value != 0 && value > performanceThreshold + 1) {
    colors = Colors.lightGreenAccent;
    iconColor = Colors.white;
    icons = Icons.arrow_upward;
  } else if (value == 0) {
    colors = Colors.grey[300]!;
    iconColor = Colors.black;
    icons = Icons.arrow_right_alt;
  } else {
    colors = Colors.grey[300]!;
    iconColor = Colors.black;
    icons = Icons.arrow_right_alt;
  }

  return CircleAvatar(
    radius: dynamicWidth(20, context),
    backgroundColor: colors,
    child: Icon(
      icons,
      color: iconColor,
    ),
  );
}