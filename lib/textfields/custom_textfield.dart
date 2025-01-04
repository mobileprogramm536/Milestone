import 'package:flutter/material.dart';
import 'package:milestone/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final double height;
  final double width;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.height = 60.0,
    this.width = 330,
    this.fontSize = 16.0,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 0.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.grey1,
        borderRadius: borderRadius,
      ),
      child: TextField(
        controller: controller,
        cursorColor: AppColors.white1,
        obscureText: obscureText,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.white1, fontSize: fontSize),
          prefixIcon: Icon(icon, color: AppColors.white1, size: iconSize),
          border: InputBorder.none, // Outline kaldırıldı
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        style: TextStyle(color: AppColors.white1, fontSize: fontSize),
      ),
    );
  }
}
