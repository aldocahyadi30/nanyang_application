import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SettingAccount extends StatefulWidget {
  const SettingAccount({super.key});

  @override
  State<SettingAccount> createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String avatarText = Provider.of<UserProvider>(context).avatarInitials!;
    String employeeName = Provider.of<UserProvider>(context).shortenedName!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Text(
              avatarText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            user != null ? employeeName : 'Nanyang',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            user != null ? user.positionName : '',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          trailing: IconButton(
            iconSize: 24,
            color: Colors.black,
            icon: const Icon(Icons.chevron_right),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
