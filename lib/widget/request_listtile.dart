import 'package:flutter/material.dart';
import 'package:nanyang_application/model/request.dart';

class RequestListtile extends StatefulWidget {
  final RequestModel model;
  const RequestListtile({super.key, required this.model});

  @override
  State<RequestListtile> createState() => _RequestListtileState();
}

class _RequestListtileState extends State<RequestListtile> {
  @override
  Widget build(BuildContext context) {
    List<String> nameParts = widget.model.requesterName.split(' ');
    String avatarText = ((nameParts.isNotEmpty ? nameParts[0][0] : '') +
            (nameParts.length > 1 ? nameParts[1][0] : ''))
        .toUpperCase();

    String employeeName = '';
    if (nameParts.length == 1) {
      employeeName = nameParts[0];
    } else if (nameParts.length == 2) {
      employeeName =
          nameParts.join(' ');
    } else {
      employeeName = nameParts.take(2).join(' ') +
          nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
    }
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          child: Text(
            avatarText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          employeeName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          widget.model.requestTypeName,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      )
    );
  }
}