import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/salary/widget/salary_admin_list.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminScreen extends StatefulWidget {
  const SalaryAdminScreen({super.key});

  @override
  State<SalaryAdminScreen> createState() => _SalaryAdminScreenState();
}

class _SalaryAdminScreenState extends State<SalaryAdminScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<SalaryViewModel>().getEmployee();
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
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: AppBar(
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SalaryAdminList(type: 1),
          SalaryAdminList(type: 2),
        ],
      ),
    );
  }
}
