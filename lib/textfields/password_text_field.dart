import 'package:flutter/material.dart';
import 'package:milestone/textfields/custom_textfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class PasswordTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'Şifre',
      icon: EvaIcons.lockOutline,
      obscureText: true,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
    );
  }
}
