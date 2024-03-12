import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/perizinan_datepicker.dart';

class PengumumanFilter extends StatefulWidget {
  final TextEditingController controller;

  const PengumumanFilter({super.key, required this.controller});

  @override
  State<PengumumanFilter> createState() => _PengumumanFilterState();
}

class _PengumumanFilterState extends State<PengumumanFilter> {
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Your modal content here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: PerizinanDatePicker(controller: widget.controller),
                onTap: () {
                  // Handle filter option 1
                  Navigator.pop(context); // Close the modal
                },
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                leading: Icon(Icons.filter_2),
                title: Text('Filter Option 2'),
                onTap: () {
                  // Handle filter option 2
                  Navigator.pop(context); // Close the modal
                },
              ),
              // Add more filter options as needed
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: 'Cari pengumuman...',
          labelStyle: const TextStyle(color: Colors.blue),
          suffixIcon: IconButton(
            onPressed: () => {
              
            },
            icon: const Icon(Icons.search, color: Colors.blue),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
