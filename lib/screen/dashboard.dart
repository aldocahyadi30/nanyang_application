import 'package:flutter/material.dart';
import 'package:nanyang_application/provider/user_provider.dart';
import 'package:nanyang_application/widget/dashboard_menu_card.dart';
import 'package:nanyang_application/widget/dashboard_pengumuman.dart';
import 'package:nanyang_application/widget/dashboard_profile_bar.dart';
import 'package:nanyang_application/widget/dashboard_request.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //MAKE FUNCTION SIGNOUT
  void signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    color: Colors.blue,
                    child: const Column(
                      children: [SizedBox(height: 48), DashboardProfileBar()],
                    )),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15),
                        const DashboardPengumuman(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.005,
                          color: Colors.grey[300],
                        ),
                        const DashboardRequest(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.005,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.15, // Adjust this value to position the card
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                child: const DashboardMenuCard(),
              ), // Your card widget goes here
            ),
          ),
        ],
      ),
    );
  }
}
