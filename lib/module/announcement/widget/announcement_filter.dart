import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_picker.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/announcement_viewmodel.dart';
import 'package:provider/provider.dart';

class AnnouncementFilter extends StatefulWidget {
  final Color color;
  final double size;

  const AnnouncementFilter({super.key, required this.color, required this.size});

  @override
  State<AnnouncementFilter> createState() => _AnnouncementFilterState();
}

class _AnnouncementFilterState extends State<AnnouncementFilter> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _filterAnnouncement(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: ColorTemplate.violetBlue.withOpacity(0.85),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(dynamicWidth(25, context)),
              topRight: Radius.circular(dynamicWidth(25, context)),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: dynamicHeight(28, context)),
              Text('Filter',
                  style: TextStyle(
                      color: const Color(0xFFE6EAFE),
                      fontSize: dynamicFontSize(24, context),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: dynamicHeight(16, context)),
              Container(
                padding: dynamicPaddingSymmetric(0, 32, context),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Kategori',
                          style: TextStyle(
                              color: ColorTemplate.darkPeriwinkle,
                              fontSize: dynamicFontSize(20, context),
                              fontWeight: FontWeight.bold)),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: context
                          .read<AnnouncementViewModel>()
                          .announcementCategory
                          .map<Widget>((e) => FilterChip(
                                backgroundColor: ColorTemplate.darkPeriwinkle,
                                label: Text(
                                  e.name,
                                  style: TextStyle(
                                    color: ColorTemplate.violetBlue,
                                    fontSize: dynamicFontSize(12, context),
                                  ),
                                ),
                                onSelected: (bool value) {},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                                ),
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: dynamicHeight(24, context)),
              Container(
                padding: dynamicPaddingSymmetric(0, 32, context),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tanggal',
                        style: TextStyle(
                          color: ColorTemplate.darkPeriwinkle,
                          fontSize: dynamicFontSize(20, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: dynamicHeight(16, context),
                    ),
                    Container(
                      width: double.infinity,
                      // Ensure the container stretches to full width
                      alignment: Alignment.topCenter,
                      // Align its child to the center
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: ColorTemplate.darkPeriwinkle,
                        borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                      ),
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.w600),
                        controller: _dateController,
                        decoration: InputDecoration(
                            contentPadding: dynamicPaddingSymmetric(0, 16, context),
                            labelText: 'Tanggal',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.w600),
                            suffixIcon: NanyangDatePicker(
                              controller: _dateController,
                              type: 'normal',
                              color: ColorTemplate.violetBlue,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _filterAnnouncement(context),
      color: widget.color,
      // iconSize: dynamicFontSize(widget.size, context),
      icon: const Icon(Icons.filter_alt),
    );
  }
}