import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:milestone/textfields/custom_textfield.dart';

class EmailTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: 'E-Posta',
      icon: EvaIcons.emailOutline,
      borderRadius: BorderRadius.zero, // Köşeler yuvarlatılmıyor
    );
  }
}
