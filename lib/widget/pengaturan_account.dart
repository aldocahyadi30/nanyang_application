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
    String avatarText = '';
    String employeeName = '';

    if (user != null) {
      List<String> nameParts = user.name.split(' ');
      avatarText = ((nameParts.isNotEmpty ? nameParts[0][0] : '') +
              (nameParts.length > 1 ? nameParts[1][0] : ''))
          .toUpperCase();

      if (nameParts.length == 1) {
        employeeName = nameParts[0]; // If there's only one word, use it as is
      } else if (nameParts.length == 2) {
        employeeName = nameParts
            .join(' '); // If there are two words, join them with a space
      } else {
        // If there are more than two words, use the first two words and abbreviate the rest
        employeeName = nameParts.take(2).join(' ') +
            nameParts.skip(2).map((name) => ' ${name[0]}.').join('');
      }
    }

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
