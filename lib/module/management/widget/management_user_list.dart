import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/module/global/other/nanyang_no_access_placeholder.dart';
import 'package:nanyang_application/module/management/widget/management_user_card.dart';
import 'package:nanyang_application/provider/configuration_provider.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ManagementUserList extends StatefulWidget {
  final int level;

  const ManagementUserList({super.key, required this.level});

  @override
  State<ManagementUserList> createState() => _ManagementUserListState();
}

class _ManagementUserListState extends State<ManagementUserList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingSymmetric(16, 16, context),
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
                    elevation: MaterialStateProperty.all<double>(0),
                    hintText: 'Cari...',
                    backgroundColor: MaterialStateProperty.all<Color>(ColorTemplate.periwinkle),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
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
                  .read<UserViewModel>()
                  .user
                  .where((UserModel user) => user.name.toLowerCase().contains(query.toLowerCase()))
                  .where((element) => element.level == widget.level)
                  .map<Widget>((request) => InkWell(
                        onTap: () {},
                        child: Container(
                          // margin: dynamicPaddingSymmetric(8, 0, context),
                          padding: dynamicPaddingSymmetric(0, 8, context),
                          child: ManagementUserCard(model: request),
                        ),
                      ))
                  .toList();
            },
          ),
          SizedBox(
            height: dynamicHeight(16, context),
          ),
          Expanded(
            child: context.read<ConfigurationProvider>().user.level >= widget.level
                ? Selector<UserViewModel, List<UserModel>>(
                    selector: (context, viewmodel) =>
                        viewmodel.user.where((element) => element.level == widget.level).toList(),
                    builder: (context, user, child) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserViewModel>().getUser();
                        },
                        child: user.isEmpty
                            ? const Center(child: NanyangEmptyPlaceholder())
                            : ListView.builder(
                                itemCount: user.length,
                                itemBuilder: (context, index) {
                                  return ManagementUserCard(model: user[index]);
                                },
                              ),
                      );
                    },
                  )
                : const Center(child: NanyangNoAccessPlaceholder()),
          ),
        ],
      ),
    );
  }
}