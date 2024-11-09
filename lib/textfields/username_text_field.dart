import 'package:flutter/material.dart';
import 'package:milestone/textfields/custom_textfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class UsernameTextField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Kullanıcı Adı',
      icon: EvaIcons.personOutline,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    );
  }
}
