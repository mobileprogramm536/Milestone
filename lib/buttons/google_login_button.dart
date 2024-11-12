import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.g_mobiledata, color: Colors.white, size: height * 0.03),
      label: Text(
        'Google',
        style: TextStyle(color: Colors.white, fontSize: height * 0.025),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.12,
          vertical: height * 0.02,
        ),
      ),
    );
  }
}
