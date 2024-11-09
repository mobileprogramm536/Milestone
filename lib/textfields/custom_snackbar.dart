import 'package:flutter/material.dart';

class CustomSnackbar {
  // Mesaj gösterme fonksiyonu
  static void showMessage(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.red,
    String actionLabel = 'Kapat',
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.yellowAccent,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
