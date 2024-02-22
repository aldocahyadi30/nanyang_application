import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PengaturanAccount extends StatefulWidget {
  const PengaturanAccount({super.key});

  @override
  State<PengaturanAccount> createState() => _PengaturanAccountState();
}

class _PengaturanAccountState extends State<PengaturanAccount> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        child: ListTile(
          leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Text(
              'AO',
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            user != null ? user.name : 'Nanyang',
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
