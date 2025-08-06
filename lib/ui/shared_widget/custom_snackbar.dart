import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomSnackBar {
  static success({required BuildContext context, required String message}) {
    _showSnackBar(context, Colors.green, message, const Duration(seconds: 4));
  }

  static warning({required BuildContext context, required String message}) {
    _showSnackBar(
        context, Colors.orangeAccent, message, const Duration(seconds: 4));
  }

  static info({required BuildContext context, required String message}) {
    _showSnackBar(
        context, Colors.blueAccent, message, const Duration(seconds: 4));
  }

  static error({required BuildContext context, required String message}) {
    _showSnackBar(context, Colors.red, message, const Duration(seconds: 4));
  }

  static _showSnackBar(BuildContext context, Color bgColor, String message,
      Duration snackBarDuration) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: snackBarDuration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: bgColor,
        content: Text(message)));
  }
}

class TopSnackBar {
  static success({required BuildContext context, required String message}) {
    _showTopSnackBar(context, Colors.green, message);
  }

  static warning({required BuildContext context, required String message}) {
    _showTopSnackBar(context, Colors.orangeAccent, message);
  }

  static info({required BuildContext context, required String message}) {
    _showTopSnackBar(context, Colors.blueAccent, message);
  }

  static error({required BuildContext context, required String message}) {
    _showTopSnackBar(context, Colors.red, message);
  }

  static _showTopSnackBar(BuildContext context, Color bgColor, String message) {
    showTopSnackBar(
        Overlay.of(context),
        Card(
          color: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 8,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
        dismissType: DismissType.onSwipe,
        dismissDirection: [
          DismissDirection.horizontal,
          DismissDirection.vertical
        ]);
  }
}
