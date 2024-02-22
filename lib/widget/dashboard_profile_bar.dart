import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardProfileBar extends StatefulWidget {
  const DashboardProfileBar({super.key});

  @override
  State<DashboardProfileBar> createState() => _DashboardProfileBarState();
}

class _DashboardProfileBarState extends State<DashboardProfileBar> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListTile(
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            'AO',
            style: TextStyle(color: Colors.black),
          ),
        ),
        title: Text(
          user != null ? user.name : 'Nanyang',
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

        trailing: IconButton(
          iconSize: 24,
          color: Colors.white,
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
      ),
    );
  }
}
