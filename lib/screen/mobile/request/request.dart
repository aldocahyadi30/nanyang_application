import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/widget/global/nanyang_appbar.dart';
import 'package:nanyang_application/widget/request/request_filter.dart';
import 'package:nanyang_application/widget/request/request_list.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final TextEditingController filterController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NanyangAppbar(
        title: 'Perizinan',
        isBackButton: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: RequestFilter(controller: filterController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  'List Perizinan',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt, color: Colors.blue),
                ),
              ),
            ],
          ),
          const Expanded(child: RequestList())
        ],
      ),
    );
  }
}