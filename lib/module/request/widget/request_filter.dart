import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/global/picker/nanyang_date_range_picker.dart';
import 'package:nanyang_application/provider/date_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestFilter extends StatefulWidget {
  final Color color;
  final double size;

  const RequestFilter({super.key, required this.color, required this.size});

  @override
  State<RequestFilter> createState() => _RequestFilterState();
}

class _RequestFilterState extends State<RequestFilter> {
  final TextEditingController _dateController = TextEditingController();
  bool _isFiltered = false;
  String _selectedStatus = 'Pending';
  List<int> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  final List<String> _jenis = [
    'Telat',
    'Pulang Lebih Awal',
    'Tidak Masuk',
    'Cuti Tahunan',
    'Sakit',
    'Cuti Hamil',
  ];

  void _resetFilter() {
    _selectedCategories.clear();
    _selectedStatus = 'Pending';
    Provider.of<DateProvider>(context, listen: false).setRequestDate(null);
    Provider.of<RequestViewModel>(context, listen: false).addFilter();
  }

  Future<void> _filterRequest(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              _isFiltered = _selectedCategories.isNotEmpty ||
                  Provider.of<DateProvider>(context, listen: false).requestDate != null ||
                  _selectedStatus != 'Pending';

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: dynamicHeight(28, context)),
                      SizedBox(
                        height: dynamicHeight(40, context),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Filter',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(0xFFE6EAFE),
                                    fontSize: dynamicFontSize(24, context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _isFiltered
                                  ? IconButton(
                                      onPressed: () => setState(() {
                                        _resetFilter();
                                      }),
                                      icon: const Icon(Icons.filter_alt_off, color: Colors.white),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: dynamicHeight(16, context)),
                      Container(
                        padding: dynamicPaddingSymmetric(0, 32, context),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Status',
                                  style: TextStyle(
                                      color: ColorTemplate.darkPeriwinkle,
                                      fontSize: dynamicFontSize(20, context),
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: dynamicHeight(16, context),
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: ColorTemplate.darkPeriwinkle,
                                borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                              ),
                              child: DropdownButton(
                                items: const [
                                  DropdownMenuItem(
                                    value: '',
                                    child: Text('Semua'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Pending',
                                    child: Text('Pending'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Approved',
                                    child: Text('Approved'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Rejected',
                                    child: Text('Ditolak'),
                                  ),
                                ],
                                padding: dynamicPaddingSymmetric(0, 16, context),
                                value: _selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStatus = value.toString();
                                    Provider.of<RequestViewModel>(context, listen: false)
                                        .addFilter(status: _selectedStatus);
                                  });
                                },
                                dropdownColor: ColorTemplate.periwinkle,
                                iconEnabledColor: ColorTemplate.violetBlue,
                                isExpanded: true,
                                style: TextStyle(
                                  fontSize: dynamicFontSize(16, context),
                                  color: ColorTemplate.violetBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                                underline: Container(),
                              ),
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
                              child: Text('Kategori',
                                  style: TextStyle(
                                      color: ColorTemplate.darkPeriwinkle,
                                      fontSize: dynamicFontSize(20, context),
                                      fontWeight: FontWeight.bold)),
                            ),
                            Wrap(
                              spacing: 12,
                              runSpacing: 1,
                              children: _jenis.asMap().entries.map((entry) {
                                int index = entry.key + 1;
                                String e = entry.value;
                                bool isSelected = _selectedCategories.contains(index);
                                return FilterChip(
                                  selected: isSelected,
                                  backgroundColor: isSelected ? ColorTemplate.periwinkle : ColorTemplate.darkPeriwinkle,
                                  label: Text(
                                    e,
                                    style: TextStyle(
                                      color: ColorTemplate.violetBlue,
                                      fontSize: dynamicFontSize(12, context),
                                    ),
                                  ),
                                  onSelected: (bool value) {
                                    setState(() {
                                      if (value) {
                                        _selectedCategories.add(index);
                                      } else {
                                        _selectedCategories.remove(index);
                                      }
                                      Provider.of<RequestViewModel>(context, listen: false)
                                          .addFilter(selectedCategory: _selectedCategories);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                                  ),
                                  side: BorderSide.none,
                                );
                              }).toList(),
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
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: ColorTemplate.darkPeriwinkle,
                                borderRadius: BorderRadius.circular(dynamicWidth(25, context)),
                              ),
                              child: TextField(
                                readOnly: true,
                                style: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
                                controller: _dateController,
                                decoration: InputDecoration(
                                    contentPadding: dynamicPaddingSymmetric(0, 16, context),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    alignLabelWithHint: true,
                                    labelStyle: const TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.w600),
                                    suffixIcon: NanyangDateRangePicker(
                                      controller: _dateController,
                                      type: 'request',
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
                      SizedBox(height: dynamicHeight(16, context)),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _filterRequest(context),
      color: widget.color,
      iconSize: dynamicFontSize(widget.size, context),
      icon: const Icon(Icons.filter_alt),
    );
  }
}