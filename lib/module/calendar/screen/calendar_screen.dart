import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/viewmodel/calendar_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lavender,
      appBar: const NanyangAppbar(
        title: 'Kalendar',
        isBackButton: true,
        isCenter: true,
      ),
      body: SingleChildScrollView(
        padding: dynamicPaddingSymmetric(0, 16, context),
        child: Consumer<CalendarViewmodel>(
          builder: (context, viewmodel, child) {
            return Column(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: TableCalendar(
                    locale: 'id_ID',
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(_today.year, 1, 1),
                    lastDay: DateTime.utc(_today.year, 12, 31),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        // Call `setState()` when updating the selected day
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          viewmodel.selectedList =
                              viewmodel.holiday.where((element) => isSameDay(element.date, selectedDay)).toList();
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        // Call `setState()` when updating calendar format
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      // No need to call `setState()` here
                      _focusedDay = focusedDay;
                    },
                    eventLoader: (day) {
                      return viewmodel.holiday
                          .where((element) => isSameDay(element.date, day))
                          .map((e) => e.name)
                          .toList();
                    },
                  ),
                ),
                SizedBox(
                  height: dynamicHeight(16, context),
                ),
                Padding(
                  padding: dynamicPaddingOnly(0, 0, 4, 0, context),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDay ?? _today)}:',
                          style: TextStyle(
                              fontSize: dynamicFontSize(16, context),
                              color: ColorTemplate.violetBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: viewmodel.selectedList.isEmpty
                              ? [
                                  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text('-',
                                          style: TextStyle(
                                              fontSize: dynamicFontSize(16, context), color: ColorTemplate.violetBlue)))
                                ]
                              : viewmodel.selectedList
                                  .map(
                                    (e) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        e.name,
                                        style: TextStyle(
                                            fontSize: dynamicFontSize(16, context), color: ColorTemplate.violetBlue),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}