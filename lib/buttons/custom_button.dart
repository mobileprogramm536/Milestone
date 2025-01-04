import 'package:flutter/material.dart';
import 'package:milestone/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String button_text;
  final VoidCallback onPressed;

  const CustomButton(
      {super.key, required this.onPressed, required this.button_text});

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
        button_text,
        style: TextStyle(
            fontSize: height * 0.022,
            fontWeight: FontWeight.bold,
            color: AppColors.white1),
      ),
    );
  }
}
