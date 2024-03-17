import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NanyangAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  const NanyangAppbar({super.key, required this.title, this.isBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: isBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          : null,
      flexibleSpace: Container(
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
      ),
      title:  Text(title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold)),
      backgroundColor: Colors.blue,
      elevation: 4,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}