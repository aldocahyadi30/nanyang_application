import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardProfileBar extends StatefulWidget {
  const DashboardProfileBar({super.key});

  @override
  State<DashboardProfileBar> createState() => _DashboardProfileBarState();
}

class _DashboardProfileBarState extends State<DashboardProfileBar> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String avatarText = '';
    String employeeName = '';

    if (user != null) {
      List<String> nameParts = user.name.split(' ');
      avatarText = ((nameParts.isNotEmpty ? nameParts[0][0] : '') +
              (nameParts.length > 1 ? nameParts[1][0] : ''))
          .toUpperCase();

      if (nameParts.length == 1) {
        employeeName = nameParts[0];
      } else if (nameParts.length == 2) {
        employeeName = nameParts
            .join(' ');
      } else {
        employeeName = nameParts.take(2).join(' ') +
            nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            avatarText,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Text(
          user != null ? employeeName : 'Nanyang',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          user != null ? user.positionName : '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            iconSize: 24,
            color: Colors.white,
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
