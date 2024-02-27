import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanyang_application/widget/perizinan_filter.dart';
import 'package:nanyang_application/widget/perizinan_list.dart';

class PerizinanScreen extends StatefulWidget {
  const PerizinanScreen({super.key});

  @override
  State<PerizinanScreen> createState() => _PerizinanScreenState();
}

class _PerizinanScreenState extends State<PerizinanScreen> {
  final TextEditingController filterController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          'Perizinan',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[200]!,
                Colors.blue,
                Colors.blue[700]!,
                Colors.blue[800]!
              ],
            ),
          ),
        ),
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: PerizinanFilter(controller: filterController),
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
          const Expanded(child: PerizinanList())
        ],
      ),
    );
  }
}
