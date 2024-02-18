import 'package:flutter/material.dart';

class DashboardMenuCard extends StatelessWidget {
  const DashboardMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.red,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.timer_rounded,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Absensi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_document,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Perizinan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.lightBlue,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.analytics,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Peformance',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.lightGreen,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.payments,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Gaji',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.red,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.timer_rounded,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Absensi',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_document,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Perizinan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.lightBlue,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.analytics,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Peformance',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IconButton(
                        color: Colors.black,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Lainnya',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
