import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FToast fToast = FToast();

void initToast(BuildContext context) {
  fToast.init(context);
}

void showToast(String message, String status) {
    IconData icon;
    Color color;

    switch(status) {
      case 'success':
        icon = Icons.check;
        color = Colors.greenAccent;
        break;
      case 'error':
        icon = Icons.error;
        color = Colors.redAccent;
        break;
      case 'warning':
        icon = Icons.warning;
        color = Colors.orangeAccent;
        break;
      default:
        icon = Icons.info;
        color = Colors.blueAccent;
        break;
    }

    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(
              width: 12.0,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 12.0),

            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
}