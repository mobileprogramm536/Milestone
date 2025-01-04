import 'package:flutter/material.dart';
import 'package:milestone/theme/colors.dart';

class RouteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;

  const RouteTextField(
      {super.key, required this.controller, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: text,
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.white1, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.white1, width: 1.5),
        ),
        focusColor: AppColors.white1,
        hintStyle:
            TextStyle(color: Colors.grey[500], fontWeight: FontWeight.normal),
      ),
      cursorColor: AppColors.white1,
      style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
    );
  }
}
