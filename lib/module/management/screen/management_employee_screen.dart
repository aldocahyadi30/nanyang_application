import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/management/widget/management_employee_list.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementEmployeeScreen extends StatefulWidget {
  final EmployeeModel? model;

  const ManagementEmployeeScreen({super.key, this.model});

  @override
  State<ManagementEmployeeScreen> createState() => _ManagementEmployeeScreenState();
}

class _ManagementEmployeeScreenState extends State<ManagementEmployeeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<EmployeeViewModel>().getEmployee();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.model == null ? ColorTemplate.lightVistaBlue : ColorTemplate.periwinkle,
      appBar: widget.model == null
          ? AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              title: Text(
                'Karyawan',
                style: TextStyle(
                    color: ColorTemplate.violetBlue,
                    fontSize: dynamicFontSize(32, context),
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40.0),
                child: Container(
                  margin: dynamicMargin(0, 0, 16, 16, context),
                  height: dynamicHeight(40, context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[600]!,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: ColorTemplate.darkVistaBlue,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: ColorTemplate.darkVistaBlue,
                    tabs: const [
                      Tab(
                        text: 'Karyawan',
                      ),
                      Tab(
                        text: 'Pekerja Cabutan',
                      ),
                    ],
                    dividerHeight: 0,
                  ),
                ),
              ),
            )
          : NanyangAppbar(
              title: 'Karyawan',
              isBackButton: true,
              isCenter: true,
              actions: [
                widget.model != null
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete, size: dynamicFontSize(32, context), color: Colors.red),
                      )
                    : Container(),
              ],
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ManagementEmployeeList(type: 1),
          ManagementEmployeeList(type: 2),
        ],
      ),
    );
  }
}