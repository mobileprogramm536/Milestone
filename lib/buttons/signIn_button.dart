import 'package:flutter/material.dart';
import 'package:milestone/theme/colors.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  SignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green1,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.22,
          vertical: height * 0.02,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        'Giriş Yap',
        style: TextStyle(
            fontSize: height * 0.022,
            fontWeight: FontWeight.bold,
            color: AppColors.white1),
      ),
    );
  }
}
