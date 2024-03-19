import 'package:flutter/material.dart';
import 'package:nanyang_application/color_template.dart';
import 'package:nanyang_application/service/request_service.dart';
import 'package:nanyang_application/size.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';

class DashboardRequest extends StatefulWidget {
  const DashboardRequest({super.key});

  @override
  State<DashboardRequest> createState() => _DashboardRequestState();
}

class _DashboardRequestState extends State<DashboardRequest> {
  late final RequestViewModel _requestViewModel;

  @override
  void initState() {
    super.initState();
    _requestViewModel = RequestViewModel(requestService: RequestService());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: dynamicPadding(0, 0, 20, 20, context),
      child: Column(
        children: [
          Row(
            children: [
               Text(
                'Permintaan',
                style: TextStyle(
                  fontSize: dynamicFontSize(20, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: ColorTemplate.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: FutureBuilder(
              future: _requestViewModel.getDashboardRequest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data?.isEmpty ?? true) {
                    return const Center(child: Text('Tidak ada perizinan'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data?[index].requestTypeName ?? 'No Title'),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}