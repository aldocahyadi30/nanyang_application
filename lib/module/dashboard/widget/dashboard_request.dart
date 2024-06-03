import 'package:flutter/material.dart';
import 'package:nanyang_application/model/request.dart';
import 'package:nanyang_application/module/global/other/nanyang_empty_placeholder.dart';
import 'package:nanyang_application/module/request/widget/request_card.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardRequest extends StatefulWidget {
  const DashboardRequest({super.key});

  @override
  State<DashboardRequest> createState() => _DashboardRequestState();
}

class _DashboardRequestState extends State<DashboardRequest> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dynamicPaddingSymmetric(4, 24, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Perizinan',
              style: TextStyle(
                fontSize: dynamicFontSize(20, context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Selector<RequestViewModel, List<RequestModel>>(
            selector: (context, viewmodel) => viewmodel.requestDashboard,
            builder: (context, request, child) {
              return request.isEmpty
                  ? const NanyangEmptyPlaceholder()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 0.0),
                      shrinkWrap: true,
                      itemCount: request.length,
                      itemBuilder: (context, index) {
                        return RequestCard(model: request[index]);
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
