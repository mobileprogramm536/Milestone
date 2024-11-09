import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:milestone/textfields/custom_textfield.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'E-Posta',
      icon: EvaIcons.emailOutline,
      borderRadius: BorderRadius.zero,
    );
  }
}
