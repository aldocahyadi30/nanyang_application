import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nanyang_application/main.dart';
import 'package:nanyang_application/helper.dart';

class ToastProvider with ChangeNotifier {
final FToast _fToast = FToast();

  ToastProvider() {
    _fToast.init(navigatorKey.currentContext!);
  }

  void showToast(String message, String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'success':
        icon = Icons.check_circle;
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

    _fToast.showToast(
      child: Container(
        padding: dynamicPaddingAll(12, _fToast.context!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dynamicWidth(8, _fToast.context!)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            SizedBox(
              width: dynamicWidth(12, _fToast.context!),
            ),
            Text(
              message,
              style:  TextStyle(color: Colors.black, fontSize: dynamicFontSize(12, _fToast.context!)),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}