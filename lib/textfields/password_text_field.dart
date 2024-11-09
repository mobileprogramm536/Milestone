import 'package:flutter/material.dart';
import 'package:milestone/textfields/custom_textfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Şifre',
      icon: EvaIcons.lockOutline,
      obscureText: true,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
    );
  }
}
