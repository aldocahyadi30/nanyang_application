import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/management/widget/management_user_form.dart';
import 'package:nanyang_application/module/management/widget/management_user_list.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserScreen extends StatefulWidget {
  final UserModel? model;
  final String type;

  const ManagementUserScreen({super.key, required this.type, this.model});

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

  void _delete (BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorTemplate.periwinkle,
          title: const Text(
            'Delete',
            style: TextStyle(color: ColorTemplate.violetBlue, fontWeight: FontWeight.bold),
          ),
          content: const Text('Apakah anda yakin untuk menghapus user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<AuthViewModel>().delete(widget.model!.id);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.type == 'list' ? ColorTemplate.lightVistaBlue : ColorTemplate.periwinkle,
      appBar: widget.type == 'list'
          ? AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              title: Text(
                'User',
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
            )
          : NanyangAppbar(
              title: 'User',
              isBackButton: true,
              isCenter: true,
              actions: [
                widget.model != null
                    ? IconButton(
                        onPressed: () => _delete(context),
                        icon: Icon(Icons.delete, size: dynamicFontSize(32, context), color: Colors.red),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: widget.type == 'list'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const ManagementUserScreen(type: 'form')));
              },
              backgroundColor: ColorTemplate.violetBlue,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: widget.type == 'list'
          ? TabBarView(
              controller: _tabController,
              children: const [
                ManagementUserList(level: 3),
                ManagementUserList(level: 2),
                ManagementUserList(level: 1)
              ],
            )
          : Container(
              padding: dynamicPaddingSymmetric(8, 16, context),
              child: widget.model == null ? const ManagementUserForm() : ManagementUserForm(model: widget.model),
            ),
    );
  }
}