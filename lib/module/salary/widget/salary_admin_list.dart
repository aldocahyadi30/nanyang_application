import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/employee.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/module/salary/widget/salary_admin_card.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/employee_viewmodel.dart';
import 'package:nanyang_application/viewmodel/salary_viewmodel.dart';
import 'package:provider/provider.dart';

class SalaryAdminList extends StatefulWidget {
  final int type;
  const SalaryAdminList({super.key, required this.type});

  @override
  State<SalaryAdminList> createState() => _SalaryAdminListState();
}

class _SalaryAdminListState extends State<SalaryAdminList> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeViewModel>().getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingOnly(16, 0, 16, 16, context),
      child: Column(
        children: [
          SearchAnchor(
            viewBackgroundColor: ColorTemplate.lightVistaBlue,
            viewHintText: 'Cari...',
            dividerColor: ColorTemplate.periwinkle,
            builder: (BuildContext context, SearchController controller) {
              return SizedBox(
                height: dynamicHeight(52, context),
                child: SearchBar(
                    elevation: WidgetStateProperty.all<double>(0),
                    hintText: 'Cari...',
                    backgroundColor: WidgetStateProperty.all<Color>(ColorTemplate.periwinkle),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(dynamicWidth(20, context)))),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    trailing: const [
                      Icon(
                        Icons.search,
                        color: ColorTemplate.violetBlue,
                      )
                    ]),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              String query = controller.text;
              return context
                  .read<SalaryViewModel>()
                  .employeeList
                  .where((EmployeeModel employee) => employee.name.toLowerCase().contains(query.toLowerCase()))
                  .where((element) => element.position.type == widget.type)
                  .map<Widget>((employee) => InkWell(
                onTap: () {},
                child: Container(
                  // margin: dynamicPaddingSymmetric(8, 0, context),
                  padding: dynamicPaddingSymmetric(0, 8, context),
                  child: SalaryAdminCard(model: employee),
                ),
              ))
                  .toList();
            },
          ),
          SizedBox(
            height: dynamicHeight(16, context),
          ),
          Expanded(
            child: Selector<SalaryViewModel, List<EmployeeModel>>(
              selector: (context, viewmodel) =>
                  viewmodel.employeeList.where((element) => element.position.type == widget.type).toList(),
              builder: (context, employee, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<SalaryViewModel>().getEmployee();
                  },
                  child: employee.isEmpty
                      ? const Center(child: NanyangEmptyPlaceholder())
                      : ListView.builder(
                    itemCount: employee.length,
                    itemBuilder: (context, index) {
                      return SalaryAdminCard(model: employee[index]);
                    },
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}
