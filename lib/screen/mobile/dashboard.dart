import 'package:flutter/material.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_menu_card.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_announcement.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_profile_bar.dart';
import 'package:nanyang_application/widget/dashboard/dashboard_request.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}



class _DashboardScreenState extends State<DashboardScreen> {
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[200]!,
                        Colors.blue,
                        Colors.blue[700]!,
                        Colors.blue[800]!
                      ],
                    ),
                  ),
                  child: const Column(
                    children: [SizedBox(height: 48), DashboardProfileBar()],
                  ),
                ),
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
                        const DashboardAnnouncement(),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        const DashboardRequest(),
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
              child: SizedBox(
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