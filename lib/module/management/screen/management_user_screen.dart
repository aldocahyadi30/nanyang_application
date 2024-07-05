import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/module/management/screen/management_user_form_screen.dart';
import 'package:nanyang_application/module/management/widget/management_user_list.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserScreen extends StatefulWidget {
  const ManagementUserScreen({super.key});

  @override
  State<ManagementUserScreen> createState() => _ManagementUserScreenState();
}

class _ManagementUserScreenState extends State<ManagementUserScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<UserViewModel>().getUser();
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
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'User',
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
                  text: 'Super Admin',
                ),
                Tab(
                  text: 'Admin',
                ),
                Tab(
                  text: 'Karyawan',
                ),
              ],
              dividerHeight: 0,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UserViewModel>().create(),
        backgroundColor: ColorTemplate.violetBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ManagementUserList(level: 3), ManagementUserList(level: 2), ManagementUserList(level: 1)],
      ),
    );
  }
}