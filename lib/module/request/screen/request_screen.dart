import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/model/user.dart';
import 'package:nanyang_application/module/global/other/nanyang_appbar.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/module/request/widget/request_card.dart';
import 'package:nanyang_application/module/request/widget/request_filter.dart';
import 'package:nanyang_application/viewmodel/auth_viewmodel.dart';
import 'package:nanyang_application/viewmodel/configuration_viewmodel.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  final String type;

  const RequestScreen({super.key, required this.type});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController filterController = TextEditingController();
  late final UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthViewModel>().user;
    context.read<RequestViewModel>().getRequest();
  }

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTemplate.lightVistaBlue,
      appBar: const NanyangAppbar(
        title: 'Perizinan',
      ),
      floatingActionButton: !_user.isAdmin
          ? FloatingActionButton(
              onPressed: () => context.read<RequestViewModel>().category(),
              backgroundColor: ColorTemplate.violetBlue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Column(
        children: [
          SizedBox(
            height: dynamicHeight(20, context),
          ),
          Expanded(
            child: Padding(
              padding: dynamicPaddingSymmetric(0, 16, context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SearchAnchor(
                          viewBackgroundColor: ColorTemplate.violetBlue,
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
                                .read<RequestViewModel>()
                                .request
                                .where((RequestModel request) => request.requester.name.toLowerCase().contains(query.toLowerCase()))
                                .map<Widget>((request) => InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin: dynamicPaddingSymmetric(8, 0, context),
                                        padding: dynamicPaddingSymmetric(0, 8, context),
                                        child: RequestCard(model: request),
                                      ),
                                    ))
                                .toList();
                          },
                        ),
                      ),
                      SizedBox(
                        width: dynamicWidth(16, context),
                      ),
                      Ink(
                        height: dynamicWidth(52, context),
                        decoration: const ShapeDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF3F51B5), Color(0xFFAAD8F9)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: CircleBorder(),
                        ),
                        child: const RequestFilter(
                          color: Colors.white,
                          size: 28,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: dynamicHeight(16, context),
                  ),
                  Expanded(
                    child: Selector<RequestViewModel, List<RequestModel>>(
                      selector: (context, viewmodel) => viewmodel.request,
                      builder: (context, request, child) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<RequestViewModel>().getRequest();
                          },
                          child: request.isEmpty
                              ? const NanyangEmptyPlaceholder()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: request.length,
                                  itemBuilder: (context, index) {
                                    return RequestCard(model: request[index]);
                                  },
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}