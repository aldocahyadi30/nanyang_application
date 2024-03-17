import 'package:flutter/material.dart';
import 'package:nanyang_application/viewmodel/request_viewmodel.dart';
import 'package:nanyang_application/widget/request/request_listtile.dart';
import 'package:provider/provider.dart';

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  late final RequestViewModel _requestViewModel;

  @override
  void initState() {
    super.initState();
    _requestViewModel = Provider.of<RequestViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: FutureBuilder(
        future: _requestViewModel.getListRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(
                child: Text('Tidak ada data'),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return RequestListtile(model: snapshot.data![index]);
                },
              );
            }
          }
        },
      ),
    );
  }
}