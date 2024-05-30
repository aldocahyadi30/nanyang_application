import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/management/widget/management_employee_list.dart';
import 'package:nanyang_application/module/salary/widget/salary_admin_detail.dart';
import 'package:nanyang_application/module/salary/widget/salary_admin_list.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminScreen extends StatefulWidget {
  final EmployeeModel? model;
  const SalaryAdminScreen({super.key, this.model});

  @override
  State<SalaryAdminScreen> createState() => _SalaryAdminScreenState();
}

class _SalaryAdminScreenState extends State<SalaryAdminScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  late bool isList = true;

  @override
  void initState() {
    super.initState();
    isList = widget.model == null;
    context.read<EmployeeViewModel>().getEmployee();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isList ? ColorTemplate.lightVistaBlue : ColorTemplate.periwinkle,
      appBar: isList
          ? AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              title: Text(
                'Gaji',
                style: TextStyle(color: ColorTemplate.violetBlue, fontSize: dynamicFontSize(32, context), fontWeight: FontWeight.bold),
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
          : const NanyangAppbar(
              title: 'Karyawan',
              isBackButton: true,
              isCenter: true,
            ),
      body: _buildBody(context, model: widget.model, tabController: _tabController),
    );
  }
}

Widget _buildBody(BuildContext context, {EmployeeModel? model, TabController? tabController}) {
  if (model == null) {
    return TabBarView(
      controller: tabController,
      children: const [
        SalaryAdminList(type: 1),
        SalaryAdminList(type: 2),
      ],
    );
  } else {
    return SalaryAdminDetail(model: model);
  }
}
